#!/usr/bin/env python3

import os, traceback, sys
import romtools as rt
from mfvitools.mml2mfvi import mml_to_akao


def akao_to_asm(data, channels, mfvi_labels):

    symbol_list = []
    label_list = []

    # add a symbol for the size of the song data
    symbol_list.append((0, '.word', 'SongEnd - Header'))

    # add labels and symbols for the start and end addresses
    label_list.append((2, 'Header'))
    label_list.append((0x26, 'SongStart'))
    label_list.append((len(data), 'SongEnd'))
    symbol_list.append((2, '.addr', 'SongStart'))
    symbol_list.append((4, '.addr', 'SongEnd'))

    # add symbols for channel start addresses
    for i in range(1, 9):
        # normal start
        label_list.append((channels[i], f'Channel{i}'))
        symbol_list.append((4 + i * 2, '.addr', f'Channel{i}'))
        # alternate start
        label_list.append((channels[i + 8], f'AltChannel{i}'))
        symbol_list.append((20 + i * 2, '.addr', f'AltChannel{i}'))

    for ref_offset in mfvi_labels:
        label_offset = mfvi_labels[ref_offset]
        label_str = rt.hex_string(label_offset, 4, '_').lower()
        label_list.append((label_offset, label_str))
        symbol_list.append((ref_offset, '.addr', label_str))

    # file header with song label
    asm_string = '.list off\n\n'
    asm_string += '; this file is generated automatically,' \
        + ' do not modify manually\n\n'
    asm_string += '.scope'
    asm_string += rt.bytes_to_asm(data, labels=label_list, symbols=symbol_list)
    asm_string += '\n\n.endscope\n\n.list on\n'

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
        variants = mml_to_akao(mml)
        def_variant = variants['_default_']
        asm_string = akao_to_asm(def_variant[0], def_variant[1],
                                    def_variant[2])
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
