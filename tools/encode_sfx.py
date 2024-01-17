#!/usr/bin/env python3

import os, traceback, sys
import romtools as rt
from mfvitools.mml2mfvi import mml_to_akao

def akao_sfx_to_asm(data, channels):

    # file header
    asm_string = '.list off\n\n'
    asm_string += '; this file is generated automatically,' \
        + ' do not modify manually\n'

    label_list = []

    # range for sfx channel 1
    range1 = rt.Range(0x26, channels[2] - 1)
    if not range1.is_empty():
        label_list.append((range1.begin - 0x26, 'Channel1'))

    # range for sfx channel 2
    range2 = rt.Range(channels[2], channels[3] - 1)
    if not range2.is_empty():
        label_list.append((range2.begin - 0x26, 'Channel2'))

    # convert bytes to asm text
    asm_string += rt.bytes_to_asm(data[0x26:], labels=label_list)
    asm_string += '\n\n.list on\n'

    return asm_string

if __name__ == '__main__':

    mml_path = sys.argv[1]
    mml_root, mml_ext = os.path.splitext(mml_path)
    asm_path = mml_root + '.asm'

    mml = []
    # read mml file
    try:
        with open(mml_path, 'r') as f:
            mml = f.readlines()
    except IOError as e:
        print(f'Error reading file {mml_path}')
        print(e)

    # convert mml file to binary and create asm string
    try:
        def_variant = mml_to_akao(mml)['_default_']
        asm_string = akao_sfx_to_asm(def_variant[0], def_variant[1])
    except Exception:
        traceback.print_exc()

    # write asm file
    try:
        os.makedirs(os.path.dirname(asm_path), exist_ok=True)
        with open(asm_path, 'w') as f:
            f.write(asm_string)
    except IOError as e:
        print(f'Error writing file {asm_path}')
        print(e)
