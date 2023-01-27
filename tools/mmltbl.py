# MMLTBL - some common tables shared by multiple MML tools

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

note_tbl = {
    "c": 0x0,
    "d": 0x2,
    "e": 0x4,
    "f": 0x5,
    "g": 0x7,
    "a": 0x9,
    "b": 0xB,
    "^": 0xC,
    "r": 0xD }
    
length_tbl = { 
    1   : (0, 0xC0),
    2   : (1, 0x60),
    3   : (2, 0x40),
    "4.": (3, 0x48),
    4   : (4, 0x30),
    6   : (5, 0x20),
    "8.": (6, 0x24),
    8   : (7, 0x18),
    12  : (8, 0x10),
    16  : (9, 0x0C),
    24  : (10, 0x08),
    32  : (11, 0x06),
    48  : (12, 0x04),
    64  : (13, 0x03) }

r_length_tbl = {
    0: "1",
    1: "2",
    2: "3",
    3: "4.",
    4: "4",
    5: "6",
    6: "8.",
    7: "8",
    8: "12",
    9: "", #default
    10: "24",
    11: "32",
    12: "48",
    13: "64" }

command_tbl = {
    ("@", 1) : 0xDC, #program
    ("|", 1) : 0xDC, #program (hex param)
    ("%a", 0): 0xE1, #reset ADSR
    ("%a", 1): 0xDD, #set attack
    ("%b", 1): 0xF7, #echo feedback (rs3)
    ("%b", 2): 0xF7, #echo feedback (ff6)
    ("%c", 1): 0xCF, #noise clock
    ("%d0", 0): 0xFC,#drum mode off (rs3)
    ("%d1", 0): 0xFB,#drum mode on (rs3)
    ("%e0", 0): 0xD5,#disable echo
    ("%e1", 0): 0xD4,#enable echo
    ("%f", 1): 0xF8, #filter (rs3)
    ("%f", 2): 0xF8, #filter (ff6)
    ("%g0", 0): 0xE7,#disable roll (enable gaps between notes)
    ("%g1", 0): 0xE6,#enable roll (disable gaps between notes)
    ("%i", 0): 0xFB, #ignore master volume (ff6)
    #("%j", 1): 0xF6 - jump to marker, segment continues
    ("%k", 1): 0xD9, #set transpose
    ("%l0", 0): 0xE5,#disable legato 
    ("%l1", 0): 0xE4,#enable legato
    ("%n0", 0): 0xD1,#disable noise
    ("%n1", 0): 0xD0,#enable noise
    ("%p0", 0): 0xD3,#disable pitch mod
    ("%p1", 0): 0xD2,#enable pitch mod
    ("%r", 0): 0xE1, #reset ADSR
    ("%r", 1): 0xE0, #set release
    ("%s", 0): 0xE1, #reset ADSR
    ("%s", 1): 0xDF, #set sustain
    ("%v", 1): 0xF2, #set echo volume
    ("%v", 2): 0xF3, #echo volume envelope
    ("%x", 1): 0xF4, #set master volume
    ("%y", 0): 0xE1, #reset ADSR
    ("%y", 1): 0xDE, #set decay
    #("j", 1): 0xF5 - jump out of loop after n iterations
    #("j", 2): 0xF5 - jump to marker after n iterations
    ("k", 1): 0xDB,  #set detune
    ("m", 0): 0xCA,  #disable vibrato
    ("m", 1): 0xDA,  #add to transpose
    ("m", 2): 0xC8,  #pitch envelope (portamento)
    ("m", 3): 0xC9,  #enable vibrato
    ("o", 1): 0xD6,  #set octave
    ("p", 0): 0xCE,  #disable pan sweep
    ("p", 1): 0xC6,  #set pan
    ("p", 2): 0xC7,  #pan envelope
    ("p", 3): 0xCD,  #pansweep
    ("s0", 1): 0xE9, #play sound effect with voice A
    ("s1", 1): 0xEA, #play sound effect with voice B
    ("t", 1): 0xF0,  #set tempo
    ("t", 2): 0xF1,  #tempo envelope
    ("u0", 0): 0xFA, #clear output code
    ("u1", 0): 0xF9, #increment output code
    ("v", 0): 0xCC,  #disable tremolo
    ("v", 1): 0xC4,  #set volume
    ("v", 2): 0xC5,  #volume envelope
    ("v", 3): 0xCB,  #set tremolo
    ("&", 1): 0xE8,  #add to note duration
    ("<", 0): 0xD7,  #increment octave
    (">", 0): 0xD8,  #decrement octave
    ("[", 0): 0xE2,  #start loop
    ("[", 1): 0xE2,  #start loop
    ("]", 0): 0xE3  #end loop
    #(":", 1): 0xFC - jump to marker if event signal is sent
    #(";", 1): 0xF6 - jump to marker, end segment
    }

byte_tbl = {
    0xC4: (1, "v"),
    0xC5: (2, "v"),
    0xC6: (1, "p"),
    0xC7: (2, "p"),
    0xC8: (2, "m"),
    0xC9: (3, "m"),
    0xCA: (0, "m"),
    0xCB: (3, "v"),
    0xCC: (0, "v"),
    0xCD: (2, "p0,"),
    0xCE: (0, "p"),
    0xCF: (1, "%c"),
    0xD0: (0, "%n1"),
    0xD1: (0, "%n0"),
    0xD2: (0, "%p1"),
    0xD3: (0, "%p0"),
    0xD4: (0, "%e1"),
    0xD5: (0, "%e0"),
    0xD6: (1, "o"),
    0xD7: (0, "<"),
    0xD8: (0, ">"),
    0xD9: (1, "%k"),
    0xDA: (1, "m"),
    0xDB: (1, "k"),
    0xDC: (1, "@"),
    0xDD: (1, "%a"),
    0xDE: (1, "%y"),
    0xDF: (1, "%s"),
    0xE0: (1, "%r"),
    0xE1: (0, "%y"),
    0xE2: (1, "["),
    0xE3: (0, "]"),
    0xE4: (0, "%l1"),
    0xE5: (0, "%l0"),
    0xE6: (0, "%g1"),
    0xE7: (0, "%g0"),
    0xE8: (1, "&"),
    0xE9: (1, "s0"),
    0xEA: (1, "s1"),
    0xEB: (0, "\n;"),
    0xF0: (1, "t"),
    0xF1: (2, "t"),
    0xF2: (1, "%v"),
    0xF3: (2, "%v"),
    0xF4: (1, "%x"),
    0xF5: (3, "j"),
    0xF6: (2, "\n;"),
    0xF7: (2, "%b"),
    0xF8: (2, "%f"),
    0xF9: (0, "u1"),
    0xFA: (0, "u0"),
    0xFB: (0, '%i'),
    0xFC: (2, ":"),
    0xFD: (1, "{FD}")
   }

equiv_tbl = {   #Commands that modify the same data, for state-aware modes (drums)
                #Treats k as the same command as v, though # params is not adjusted
    "v0,0": "v0",
    "p0,0": "p0",
    "v0,0,0": "v",
    "m0,0,0": "m",
    "|0": "@0",
    "%a": "%y",
    "%s": "%y",
    "%r": "%y",
    "|": "@0",
    "@": "@0",
    "o": "o0",
    }