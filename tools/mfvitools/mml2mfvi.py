#!/usr/bin/env python3

# MML2MFVI - convert human-writable / macro-enabled MML files to
# BGM sequence data formatted for Final Fantasy VI

# *** READ THIS BEFORE EDITING THIS FILE ***

# This file is part of the mfvitools project.
# ( https://github.com/emberling/mfvitools )
# mfvitools is designed to be used inside larger projects, e.g.
# johnnydmad, Beyond Chaos, Beyond Chaos Gaiden, or potentially
# others in the future.
# If you are editing this file as part of "johnnydmad," "Beyond Chaos,"
# or any other container project, please respect the independence
# of these projects:
# - Keep mfvitools project files in a subdirectory, and do not modify
#   the directory structure or mix in arbitrary code files specific to
#   your project.
# - Keep changes to mfvitools files in this repository to a minimum.
#   Don't make style changes to code based on the standards of your
#   containing project. Don't remove functionality that you feel your
#   containing project won't need. Keep it simple so that code and
#   changes can be easily shared across projects.
# - Major changes and improvements should be handled through, or at
#   minimum shared with, the mfvitools project, whether through
#   submitting changes or through creating a fork that other mfvitools
#   maintainers can easily see and pull from.

import sys, os, re, traceback, copy, math
try:
    from mmltbl import *
except ImportError:
    from .mmltbl import *

mml_log = "\n" if __name__ == "__main__" else None

def byte_insert(data, position, newdata, maxlength=0, end=0):
    while position > len(data):
        data = data + b"\x00"
    if end:
        maxlength = end - position + 1
    if maxlength and len(newdata) > maxlength:
        newdata = newdata[:maxlength]
    return data[:position] + newdata + data[position+len(newdata):]

def int_insert(data, position, newdata, length, reversed=True):
    n = int(newdata)
    l = []
    while len(l) < length:
        l.append(n & 0xFF)
        n = n >> 8
    if not reversed: l.reverse()
    return byte_insert(data, position, bytes(l), length)

def warn(fileid, cmd, msg):
    global mml_log
    m = "{}: WARNING: in {:<10}: {}".format(fileid, cmd, msg)
    print(m)
    if __name__ == "__main__": mml_log += m + '\n'

def mlog(msg):
    global mml_log
    if __name__ == "__main__": mml_log += msg + '\n'
    
class Drum:
    def __init__(self, st):
        s = re.findall('(.)(.[+-]?)\\1=\s*([0-9]?)([a-gr^])([+-]?)\s*(.*)', st)
        if s: s = s[0]
        mlog("{} -> {}".format(st, s))
        if len(s) >= 6:
            self.delim = s[0]
            self.key = s[1]
            self.octave = int(s[2]) if s[2] else 5
            self.note = s[3] + s[4]
            s5 = re.sub('\s*', '', s[5]).lower()
            params = re.findall("\|[0-9a-f]|@0x[0-9a-f][0-9a-f]|%?[^|0-9][0-9,]*", s5)
            par = {}
            for p in params:
                if p[0] == "@" and len(p) >= 5:
                    if p[0:3] == "@0x":
                        par['@0'] = str(int(p[3:5], 16))
                        continue
                if p[0] == '|' and len(p) >= 2:
                    par['@0'] = str(int(p[1], 16) + 32)
                else:
                    pre = re.sub('[0-9]+', '0', p)
                    suf = re.sub('%?[^0-9]', '', p, 1)
                    if pre in equiv_tbl:
                        pre = equiv_tbl[pre]
                    par[pre] = suf
            self.params = par
        else:
            self.delim, self.key, self.octave, self.note, self.params = None, None, None, None, None
        mlog("DRUM: [{}] {} -- o{} {} {}".format(self.delim, self.key, self.octave, self.note, self.params))
        
def get_variant_list(mml, sfxmode=False):
    if isinstance(mml, str):
        mml = mml.splitlines()
        
    all_delims = set()
    for line in mml:
        if line.startswith("#SFXV") and len(line) > 5:
            tokens = line[5:].split()
            if len(tokens) < 1: continue
            if len(tokens) >= 2 and sfxmode:
                all_delims.update(tokens[1])
            elif not sfxmode:
                all_delims.update(tokens[0])
    variants = {}
    for line in mml:
        if line.startswith("#VARIANT") and len(line) > 8:
            makedefault = True if not variants else False
            tokens = line[8:].split()
            if len(tokens) < 1: continue
            if len(tokens) == 1:
                tokens.append('_default_')
            all_delims.update(tokens[0])
            variants[tokens[1]] = tokens[0]
            if makedefault: variants["_default_"] = tokens[0]
    for k, v in list(variants.items()):
        variants[k] = "".join([c for c in all_delims if c not in variants[k]])
    if not variants:
        variants['_default_'] = ''.join([c for c in all_delims])
    return variants
    
def get_echo_delay(mml, variant=None):
    variants = get_variant_list(mml)
    if not variant:
        variant = "_default_"
    vtokens = variants[variant]
    for line in mml:
        if line.upper().startswith("#EDL") and len(line) > 4:
            line = line[4:]
            for c in vtokens:
                if c in line:
                    line = re.sub(re.escape(c)+'.*?'+re.escape(c), '', line)
            line = re.sub('[^0-9]+', '', line)
            try:
                num = int(line)
            except ValueError:
                print(f"Invalid EDL value [{line}]")
                return None
            if num > 15:
                print(f"EDL value too high ({num}) -- max is 15")
                return None
            return num
    return None
                        
def get_brr_imports(mml, variant=None):
    variants = get_variant_list(mml)
    if variant not in variants:
        print(f"BRRIMPORT: requested variant '{variant}' not present in mml, reverting to default")
    if not variant:
        variant = "_default_"

    brr_import_info = {}
    vtokens = variants[variant]
    try: #if it's not a list of lines, we need it to be one
        mml = mml.split('\n')
    except AttributeError: 
        pass
    for line in mml:
        if line.upper().startswith("#BRR") and len(line) > 4:
            line = line[4:]
            for c in vtokens:
                spline = line.split(';')
                if c in spline[0]:
                    spline[0] = re.sub(re.escape(c)+'.*?'+re.escape(c), '', spline[0])
                line = ';'.join(spline)
            if ';' in line:
                prog, _, meta = line.partition(';')
            
                prog = prog.strip().lower().split()
                if prog == "":
                    continue
                base = 16 if 'x' in prog[0] else 10
                prog_ = prog[0].replace('x', '')
                try:
                    prog = int(prog_, base)
                except ValueError:
                    print(f"BRRIMPORT: couldn't parse program value '{prog}'")
                    continue
                if prog < 0x20 or prog >= 0x30:
                    continue
                    
                meta = meta.strip().split(',')
                if len(meta) < 2:
                    print(f"BRRIMPORT: no loop specified for program 0x{prog:02X}, defaulting to 0")
                    meta.append('0000')
                if len(meta) < 3:
                    print(f"BRRIMPORT: no tuning specified for program 0x{prog:02X}, defaulting to 0")
                    meta.append('0000')
                if len(meta) < 4:
                    print(f"BRRIMPORT: no ADSR specified for program 0x{prog:02X}, defaulting to a15d7s7r0")
                    meta.append('FFE0')
                brr_import_info[prog] = meta
    return brr_import_info
    
def parse_brr_loop(looptext):
    looptext = looptext.strip().lower()
    if looptext == "brr" or looptext == "inline" or looptext is None:
        return None
    try:
        if looptext.startswith("@"):
            looptext = looptext[1:]
            loopmult = 1
            if looptext.endswith("bl"):
                loopmult = 9
                looptext = looptext[:-2]
            elif looptext.endswith("smp"):
                loopmult = 9/16
                looptext = looptext[:-3]
            if looptext.startswith("0x"):
                loop = int(round(int(looptext[2:], 16) * loopmult))
            else:
                loop = int(round(int(looptext) * loopmult))
            byteloop = loop.to_bytes(2, "little")
        else:
            byteloop = int(looptext, 16).to_bytes(2, "big")
    except ValueError:
        byteloop = b"\x00\x00"
        print(f"PARSEBRRINFO: bad loop data formatting ({looptext}), defaulting to 0000")
    return byteloop
       
def parse_brr_tuning(pitchtext):
    pitchtext = pitchtext.strip().lower()
    keytable = {"a": 0, "b": 10, "c": 9, "d": 7, "e": 5, "f": 4, "g": 2}
    semitones = None
    pitchscale = None
    try:
        match = re.fullmatch("(\\^?)([a-g])([+-]?)\\s?([+-]\\d+)", pitchtext)
        if match:
            high, key, mod, cents = match.group(1, 2, 3, 4)
            cents = int(cents)
        if not match:
            match = re.fullmatch("(\\^?)([a-g])([+-]?)", pitchtext)
            if match:
                high, key, mod = match.group(1, 2, 3)
                cents = 0
        if match:
            semitones = -12 if high else 0
            semitones += keytable[key]
            if mod == "+":
                semitones -= 1
            elif mod == "-":
                semitones += 1
            semitones -= (cents/100)
            #print(f"DEBUG: tuning '{pitchtext}' -> {semitones} st")
        if semitones is None and len(pitchtext):
            if pitchtext[0] in ["+", "-"]:
                semitones = float(pitchtext)
        if semitones is not None:
            pitchscale = 10 ** ((semitones / 12) * math.log(2, 10))
            #print(f"DEBUG: pitch scale {pitchscale}")
        elif len(pitchtext) and pitchtext[0] == "*":
            pitchscale = float(pitchtext[1:])  
        if pitchscale is not None:
            max_pitchscale = 1.5 - (1 / 65536)
            while pitchscale < 0.5:
                pitchscale *= 2
                #print(f"DEBUG: pitch scale too low, raising octave")
            while pitchscale > max_pitchscale:
                pitchscale /= 2
                #print(f"DEBUG: pitch scale too high, lowering octave")
            pitchval = int((pitchscale * 65536) - 65536)
            bytepitch = pitchval.to_bytes(2, "big", signed=True)
        else:
            bytepitch = int(pitchtext, 16).to_bytes(2, "big")
    except ValueError:
        bytepitch = b"\x00\x00"
        print(f"PARSEBRRINFO: bad tuning data formatting ({pitchtext}), defaulting to 0000")
    return bytepitch
        
def parse_brr_env(envtext):
    envtext = envtext.strip().lower()
    byteenv = None
    try:
        envsplit = envtext.split()
        match = re.fullmatch("a(\\d\\d?)\\s?[dy](\\d)\\s?s(\\d)\\s?r(\\d\\d?)", envtext)
        if match:
            attack, decay, sustain, release = match.group(1, 2, 3, 4)
        elif len(envsplit) >= 4:
            attack, decay, sustain, release = [int(i, 16) for i in envsplit[0:4]]
        else:
            byteenv = int(envtext, 16).to_bytes(2, "big")
        if byteenv is None:
            attack, decay, sustain, release = [int(i) for i in (attack, decay, sustain, release)]
            if attack > 15 or decay > 7 or sustain > 7 or release > 31:
                raise ValueError(f"Envelope component too large -- a{attack} d{decay} s{sustain} r{release}")
            firstbyte = 0b10000000 + (decay << 4) + attack
            secondbyte = (sustain << 5) + release
            byteenv = bytes([firstbyte, secondbyte])
    except ValueError:
        byteenv = b"\xFF\xE0"
        print(f"PARSEBRRINFO: bad adsr data formatting ({envtext}), defaulting to a15d7s7r0")
    return byteenv
    
def mml_to_akao(mml, fileid='mml', sfxmode=False, variant=None, inst_only=False):
    #preprocessor
    #returns dict of (data, inst) tuples (4096, 32 bytes max)
    #one generated for each #VARIANT directive

    if isinstance(mml, str):
        mml = mml.splitlines()
    #one-to-one character replacement
    transes = []
    for line in mml:
        if line.startswith("#REPLACE") and len(line) > 7:
            tokens = line[7:].split()
            if len(tokens) < 3: continue
            if len(tokens[1]) != len(tokens[2]):
                warn(fileid, line, "token size mismatch, ignoring excess")
                if len(tokens[1]) > len(tokens[2]):
                    tokens[1] = tokens[1][0:len(tokens[2])]
                else:
                    tokens[2] = tokens[2][0:len(tokens[1])]
            transes.append(str.maketrans(tokens[1], tokens[2]))
    for trans in transes:
        newmml = []
        for line in mml:
            newmml.append(line.translate(trans))
        mml = newmml
    
    variants = get_variant_list(mml, sfxmode)
    if variant:
        if variant not in variants:
            print("mml error: requested unknown variant '{}'\n".format(variant))
            variants = {'_default_': variants['_default_']}
        else:
            variants = {variant: variants[variant]}
        
    #generate instruments
    isets = {}
    for k, v in variants.items():
        iset = {}
        for line in mml:
            uline = line.upper()
            if uline.startswith("#WAVE") or uline.startswith("#BRR"):
                for c in v:
                    if c in line:
                        line = re.sub(re.escape(c)+'.*?'+re.escape(c), '', line)
            uline = line.upper()
            if uline.startswith("#BRR") and len(line) > 4 and not inst_only:
                # skipping this in inst_only because it'll be overwritten anyway so
                # will produce false positives wrt inst_only's use case
                line = line[4:].partition(';')[0]
                line = "#WAVE " + line
                uline = line.upper()
            if uline.startswith("#WAVE") and len(line) > 5:
                line = re.sub('[^x\da-fA-F]', ' ', line[5:])
                tokens = line.split()
                if len(tokens) < 2: continue
                numbers = []
                for t in tokens[0:2]:
                    t = t.lower()
                    base = 16 if 'x' in t else 10
                    t = t.replace('x' if base == 16 else 'xabcdef', '')
                    try:
                        numbers.append(int(t, base))
                    except:
                        warn(fileid, "#WAVE {}, {}".format(tokens[0], tokens[1]), "Couldn't parse token {}".format(t))
                        continue
                if numbers[0] not in list(range(0x20,0x30)):
                    warn(fileid, "#WAVE {}, {}".format(hex(numbers[0]), hex(numbers[1])), "Program ID out of range (expected 0x20 - 0x2F / 32 - 47)")
                    continue
                if numbers[1] not in list(range(0, 256)):
                    warn(fileid, "#WAVE {}, {}".format(hex(numbers[0]), hex(numbers[1])), "Sample ID out of range (expected 0x00 - 0xFF / 0 - 255)")
                    continue
                iset[numbers[0]] = numbers[1]
        raw_iset = b"\x00" * 0x20
        for slot, inst in iset.items():
            raw_iset = byte_insert(raw_iset, (slot - 0x20)*2, bytes([inst]))
        isets[k] = raw_iset
                
    #return if only parsing for inst
    if inst_only:
        if variant in variants:
            return isets[variant]
        else:
            return isets
        
    #generate data
    datas, channels, jumps = {}, {}, {}
    for k, v in variants.items():
        if variant in variants and k != variant:
            continue
        datas[k], channels[k], jumps[k] = mml_to_akao_main(mml, v, fileid)
    
    if variant in variants:
        return (datas[variant], channels[variant], jumps[variant], isets[variant])
    else:
        output = {}
        for k, v in variants.items():
            output[k] = (datas[k], channels[k], jumps[k], isets[k])
        
        return output
        
        
def mml_to_akao_main(mml, ignore='', fileid='mml'):
    mml = copy.copy(mml)
    ##final bit of preprocessing
    #single character macros
    cdefs = {}
    for line in mml:
        if line.lower().startswith("#cdef"):
            li = line[5:]
            li = li.split('#')[0].lower().strip()
            li = li.split(None, 1)
            if len(li) < 2: continue
            if len(li[0]) != 1:
                warn(fileid, line, "Expected one character for cdef, found {} ({})").format(len(li[0]), li[0])
                continue
            cdefs[li[0]] = li[1]
    #single quote macros
    macros = {}
    for line in mml:
        if line.lower().startswith("#def"):
            line = line[4:]
            line = line.split('#')[0].lower()
            if not line: continue
            pre, sep, post = line.partition('=')
            if post:
                pre = pre.replace("'", "").strip()
                for c in ignore:
                    try:
                        post = re.sub(re.escape(c)+".*?"+re.escape(c), "", post)
                    except Exception:
                        c = "\\" + c
                        post = re.sub(re.escape(c)+".*?"+re.escape(c), "", post)
                    post = "".join(post.split())
                macros[pre] = post.lower()
    
    for i, line in enumerate(mml):
        while True:
            r = re.search("'(.*?)'", line)
            if not r: break
            mx = r.group(1)
            #
            m = re.search("([^+\-*]+)", mx).group(1)
            tweaks = {}
            tweak_text = ""
            while True:
                twx = re.search("([+\-*])([%a-z]+)([0-9.,]+)", mx)
                if not twx: break
                tweak_text += twx.group(0)
                cmd = twx.group(2) + ''.join([c for c in twx.group(3) if c == ','])
                tweaks[cmd] = (twx.group(1), twx.group(3))
                mx = mx.replace(twx.group(0), "", 1)
            #
            s = macros[m.lower()] if m.lower() in macros else ""
            p = 0
            if tweaks:
                # "o,,": ("+", ",1,")
                skip = ignore + "\"'{"
                sq = list(s)
                sr = ""
                while sq:
                    c = sq.pop(0)
                    if c in skip:
                        endat = "}" if c=="{" else c
                        if sq: c += sq.pop(0)
                        while sq:
                            cc = sq.pop(0)
                            if cc == endat:
                                if endat == "'": c += tweak_text
                                c += cc
                                break
                            else: c += cc
                        sr += c
                        continue
                    if sq and c == "%":
                        c += sq.pop(0)
                    d = ""
                    while sq and sq[0] in "1234567890,.+-x":
                        d += sq.pop(0)
                    cmd = c + ''.join([ch for ch in d if ch == ','])
                    if d and (cmd in tweaks):
                        d = d.split(',')
                        e = tweaks[cmd][1].split(',')
                        sign = tweaks[cmd][0]
                        for j, ee in enumerate(e):
                            if not ee:
                                c += f"{d[j]},"
                                continue
                            try: en = int(ee)
                            except:
                                try: en = int(ee,16)
                                except:
                                    try: en = float(ee)
                                    except:
                                        warn(fileid, s, "error parsing {} into {}".format(r.group(0), s))
                                        en = 0
                            try: dn = int(d[j])
                            except:
                                try: dn = int(d[j],16)
                                except:
                                    warn(fileid, m, "error parsing {} into {}".format(r.group(0), s))      
                                    dn = 0
                            if sign == "*":
                                result = dn * en
                            elif sign == "-":
                                result = dn - en
                            elif sign == "+":
                                result = dn + en
                            if result < 0: result = 0
                            if ((cmd == "v" or cmd == "p") and j==0) or ((cmd == "v," or cmd == "p,") and j==1):
                                if result > 127: result = 127
                            else:
                                if result > 255: result = 255
                            #apply new values
                            c += f"{int(result)},"
                        c = c.rstrip(',')
                    else: c += d
                    sr += c
                s = sr
                                                    
            line = line.replace(r.group(0), s, 1)
            
        mml[i] = line.replace('\n', ' ')
        
    #drums
    drums = {}
    for line in mml:
        if line.lower().startswith("#drum"):
            s = line[5:].strip()
            s = s.split('#')[0].lower()
            for c in ignore:
                try:
                    s = re.sub(re.escape(c)+".*?"+re.escape(c), "", s)
                except Exception:
                    c = "\\" + c
                    s = re.sub(re.escape(c)+".*?"+re.escape(c), "", s)
            for c in ["~", "/", "`", "\?", "_"]:
                s = re.sub(c, '', s)
            d = Drum(s.strip())
            if d.delim:
                if d.delim not in drums: drums[d.delim] = {}
                drums[d.delim][d.key] = d
    
    for i, line in enumerate(mml):
        mml[i] = line.split('#')[0].lower()
            
    m = list(" ".join(mml))
    targets, channels, pendingjumps, jumps = {}, {}, {}, {}
    data = b"\x00" * 0x26
    defaultlength = 8
    thissegment = 1
    next_jumpid = 1
    state = {}
    jumpout = []
    
    while len(m):
        command = m.pop(0)
                        
        #single character macros
        if command in cdefs:
            repl = list(cdefs[command] + " ")
            m = repl + m
        #conditionally executed statements
        if command in ignore:
            while len(m):
                next = m.pop(0)
                if next == command:
                    break
            continue
        #inline comment // channel marker
        elif command == "{":
            thisnumber = ""    
            numbers = []
            while len(m):
                command += m.pop(0)
                if command[-1] in "1234567890":
                    thisnumber += command[-1]
                elif thisnumber:
                    numbers.append(int(thisnumber))
                    thisnumber = ""
                if command[-1] == "}": break
            for n in numbers:
                if n <= 16 and n >= 1:
                    channels[n] = len(data)
            continue
        #drum mode
        elif command in drums:
            mls, dms = [], []
            drumset = drums[command]
            while len(m):
                if m[0] != command:
                    dms.append(m.pop(0))
                else:
                    m.pop(0)
                    break
            dbgdms = "".join(dms)
            lockstate = False
            silent = False
            if len(dms):
                if dms[0] in "1234567890":
                    state["o0"] = dms.pop(0)
                elif dms[0] == ">":
                    co = dms.pop(0)
                    while dms[0] == ">":
                        co += dms.pop(0)
                    if "o0" in state:
                        state["o0"] += len(co)
                elif dms[0] == "<":
                    co = dms.pop(0)
                    while dms[0] == "<":
                        co += dms.pop(0)
                    if "o0" in state:
                        state["o0"] -= len(co)
            while len(dms):
                if "m0,0" in state:
                    state.pop("m0,0", None)
                dcom = dms.pop(0)
                if len(dms):
                    if dms[0] in "+-":
                        dcom += dms.pop(0)
                if dcom == "\\":
                    lockstate = True if not lockstate else False
                elif dcom == ":":
                    silent = True if not silent else False
                elif dcom == "!":
                    rcom = dms.pop(0)
                    if rcom == "!":
                        if "o0" in state:
                            state = {"o0": state["o0"]}
                        else:
                            state = {}
                        continue
                    if rcom == "%": rcom += dms.pop(0)
                    while len(dms):
                        if dms[0] in "0,":
                            rcom += dms.pop(0)
                        else: break
                    if rcom in equiv_tbl:
                        rcom = equiv_tbl[rcom]
                    state.pop(rcom, None)
                elif dcom in "0123456789^.":
                    mls.extend(dcom)
                elif dcom in drumset:
                    params = {}
                    deferred_env_params = {}
                    #print(f"{dcom=}\n{drumset[dcom].params=}")
                    for k, v in drumset[dcom].params.items():
                        if lockstate and k != "@0": continue
                        if k in state:
                            if state[k] != v:
                                params[k] = v
                            elif k in ["%a0", "%y0", "%s0", "%r0"]:
                                #print(f"deferring {k},{v}")
                                deferred_env_params[k] = v
                        elif k == "%y" and not ( "%a0" in state or "%y0" in state or 
                                                 "%s0" in state or "%r0" in state):
                             pass
                        else:
                            params[k] = v
                    s = ""
                    if "%y" in params or "@0" in params:
                        state.pop("%a0", None)
                        state.pop("%y0", None)
                        state.pop("%s0", None)
                        state.pop("%r0", None)
                        params.update(deferred_env_params)
                    for k, v in params.items():
                        t = (re.sub('[0-9,]', '', k) + v).strip()
                        s = t + s if k == "@0" else s + t
                        if k != "%y":
                            state[k] = v
                        
                    if 'o0' in state:
                        if isinstance(state['o0'], str): state['o0'] = int(state['o0'])
                        ochg = drumset[dcom].octave - int(state['o0'])
                        if abs(ochg) <= 1:
                            if ochg < 0:
                                s += ">" * abs(ochg)
                            else: s += "<" * ochg
                        else:
                            s += "o{}".format(drumset[dcom].octave)
                        state['o0'] += ochg
                    else:
                        s += "o{}".format(drumset[dcom].octave)
                        state['o0'] = drumset[dcom].octave
                    s += drumset[dcom].note
                    if not silent: mls.extend(list(s))
            mlog("drum: processed {} -> {}".format(dbgdms, "".join(mls)))
            mls.extend(m)
            m = mls
            continue
            
        #populate command variables
        if command == "%": command += m.pop(0)
        prefix = command
        if len(m):
            while m[0] in "1234567890,.+-x":
                command += m.pop(0)
                if not len(m): break
        
        #catch @0x before parsing params
        if "|" in command:
            command = "@0x2" + command[1:]
        if "@0x" in command:
            while len(command) < 5:
                command += m.pop(0)
            number = command[-2:]
            try:
                number = int(number, 16)
            except ValueError:
                warn(fileid, command, "Invalid instrument {}, falling back to 0x20".format(number))
                number = 0x20
            command = "@" + str(number)
                    
        modifier = ""
        params = []
        for c in command:
            if c in "+-":
                modifier = c
        thisnumber = ""
        is_negative = False
        for c in command[len(prefix):] + " ":
            if c in "1234567890":
                thisnumber += c
            elif c == "-" and prefix not in "abcdefg^r":
                is_negative = True
            elif thisnumber:
                params.append(0x100-int(thisnumber) if is_negative else int(thisnumber))
                thisnumber = ""
                is_negative = False
        dots = len([c for c in command if c == "."])
        
        if (prefix, len(params)) not in command_tbl and len(params):
            if (prefix + str(params[0]), len(params) - 1) in command_tbl:
                prefix += str(params.pop(0))
        
        #print "processing command {} -> {} {} mod {} dots {}".format(command, prefix, params, modifier, dots)
        #case: notes
        if prefix in "abcdefg^r":
            pitch = note_tbl[prefix]
            if prefix not in "^r":
                pitch += 1 if "+" in modifier else 0
                pitch -= 1 if "-" in modifier else 0
                while pitch < 0: pitch += 0xC
                while pitch > 0xB: pitch -= 0xC
            if not params:
                length = defaultlength
            else:
                length = params[0]
            if dots and str(length)+"." in length_tbl:
                akao = bytes([pitch * 14 + length_tbl[str(length)+"."][0]])
                dots -= 1
                length *= 2
            elif length in length_tbl:
                akao = bytes([pitch * 14 + length_tbl[length][0]])
            else:
                warn(fileid, command, "Unrecognized note length {}".format(length))
                continue
            while dots:
                if length*2 not in length_tbl:
                    warn(fileid, command, "Cannot extend note/tie of length {}".format(length))
                    break
                dots -= 1
                length *= 2
                if dots and str(length)+"." in length_tbl:
                    akao += bytes([note_tbl["^"]*14 + length_tbl[str(length)+"."][0]])
                    dots -= 1
                    length *= 2
                else:
                    akao += bytes([note_tbl["^"]*14 + length_tbl[length][0]])
            data += akao
        #case: simple commands
        elif (prefix, len(params)) in command_tbl:
            #special case: loops
            if prefix == "[":
                if len(params):
                    params[0] -= 1
                else:
                    params.append(1)
            #special case: end loop adds jump target if j,1 is used
            if prefix == "]":
                while len(jumpout):
                    pendingjumps[jumpout.pop()] = "jo%d"%next_jumpid
                    jumps[jumpout.pop()] = "jo%d"%next_jumpid
                targets["jo%d"%next_jumpid] = len(data) + 1
                next_jumpid += 1    
            #general case
            akao = bytes([command_tbl[prefix, len(params)]])
            #special case: pansweep
            if prefix == "p" and len(params) == 3:
                params = params[1:]
            #general case
            while len(params):
                if params[0] >= 256:
                    warn(fileid, command, "Parameter {} out of range, substituting 0".format(params[0]))
                    params[0] = 0
                akao += bytes([params.pop(0)])
            data += akao
        #case: default length
        elif prefix == "l" and len(params) == 1:
            if params[0] in length_tbl:
                defaultlength = params[0]
            else:
                warn(fileid, command, "Unrecognized note length {}".format(length))
        #case: jump point
        elif prefix == "$":
            if params:
                targets[params[0]] = len(data)
            else:
                targets["seg%d"%thissegment] = len(data)
        #case: end of segment
        elif prefix == ";":
            defaultlength = 8
            state = {}
            if params:
                if params[0] in targets:
                    target = targets[params[0]]
                    jumps[len(data)+1] = target
                else:
                    target = len(data)
                    pendingjumps[len(data)+1] = params[0]
                    jumps[len(data)+1] = params[0]
            else:
                if "seg%d"%thissegment in targets:
                    target = targets["seg%d"%thissegment]
                    jumps[len(data)+1] = target
                else:
                    data += b"\xEB"
                    thissegment += 1
                    continue
            data += b"\xF6" + int_insert(b"\x00\x00",0,target,2)
            thissegment += 1
        #case: jump out of loop
        elif prefix == "j":
            if len(params) == 1:
                jumpout.append(len(data)+2)
                target = len(data)
            elif len(params) == 2:
                if params[1] in targets:
                    target = targets[params[1]]
                    jumps[len(data)+2] = target
                else:
                    target = len(data)
                    pendingjumps[len(data)+2] = params[1]
                    jumps[len(data)+2] = params[1]
            else: continue
            if params[0] >= 256:
                warn(fileid, command, "Parameter {} out of range, substituting 1".format(params[0]))
                params[0] = 1
            data += b"\xF5" + bytes([params[0]]) + int_insert(b"\x00\x00",0,target,2)
        #case: hard jump without ending segment
        elif prefix == "%j":
            if len(params)==1:
                if params[0] in targets:
                    target = targets[params[0]]
                    jumps[len(data)+1] = target
                else:
                    target = len(data)
                    pendingjumps[len(data)+1] = params[0]
                    jumps[len(data)+1] = params[0]
            else: continue
            data += b"\xF6" + int_insert(b"\x00\x00",0,target,2)
        #case: conditional jump
        elif prefix == ":" and len(params) == 1:
            if params[0] in targets:
                target = targets[params[0]]
                jumps[len(data)+1] = target
            else:
                target = len(data)
                pendingjumps[len(data)+1] = params[0]
                jumps[len(data)+1] = params[0]
            data += b"\xFC" + int_insert(b"\x00\x00",0,target,2)
    
    #insert pending jumps
    for k, v in pendingjumps.items():
        if v in targets:
            data = int_insert(data, k, targets[v], 2)
            jumps[k] = targets[v]
        else:
            warn(fileid, command, "Jump destination {} not found in file".format(v))
            
    #set up header
    header = int_insert(b"\x00"*0x26, 0, len(data)-3, 2)
    header = int_insert(header, 2, 0x26, 2)
    header = int_insert(header, 4, len(data), 2)
    for i in range(1,9):
        if i not in channels:
            channels[i] = len(data)
    temp = {}
    for k, v in channels.items():
        header = int_insert(header, 4 + k*2, v, 2)
        if k <= 8 and k+8 not in channels:
            header = int_insert(header, 4 + (k+8)*2, v, 2)
            temp[k+8] = channels[k]
    data = byte_insert(data, 0, header, 0x26)
    channels.update(temp)

    return data, channels, jumps
    
def clean_end():
    print("Processing ended.")
    input("Press enter to close.")
    quit()
    
if __name__ == "__main__":
    mml_log = "\n"

    print("mfvitools MML to AKAO SNESv4 converter")
    print()
    
    if len(sys.argv) >= 2:
        fn = sys.argv[1]
    else:
        print("Enter MML filename..")
        fn = input(" > ").replace('"','').strip()
    
    try:
        with open(fn, 'r') as f:
            mml = f.readlines()
    except IOError:
        print("Error reading file {}".format(fn))
        clean_end()

    try:
        variants = mml_to_akao(mml)
    except Exception:
        traceback.print_exc()
        clean_end()
    
    fn = os.path.splitext(fn)[0]
    for k, v in variants.items():
        vfn = ".bin" if k in ("_default_", "") else "_{}.bin".format(k)
        
        thisfn = fn + "_data" + vfn
        try:
            with open(thisfn, 'wb') as f:
                f.write(bytes(v[0]))
        except IOError:
            print("Error writing file {}".format(thisfn))
            clean_end()
        print("Wrote {} - {} bytes".format(thisfn, hex(len(v[0]))))
        
        thisfn = fn + "_inst" + vfn
        try:
            with open(thisfn, 'wb') as f:
                f.write(bytes(v[1]))
        except IOError:
            print("Error writing file {}".format(thisfn))
            clean_end()
        print("Wrote {}".format(thisfn))
        
    try:
        with open(os.path.join(os.path.split(sys.argv[0])[0],"mml_log.txt"), 'w') as f:
            f.write(mml_log)
    except IOError:
        print("Couldn't write log file, displaying...")
        print(mml_log)
            
    print("Conversion successful.")
    print()
    
    clean_end()
