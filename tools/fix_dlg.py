#!/usr/bin/env python3

import romtools as rt
import os
import sys
import json
from encode_text import encode_text, update_text_inc


def split_dlg(dlg1_def, dlg2_def):

    # find the first dialog offset beyond the first bank
    item_offsets, _ = encode_text(dlg1_def)
    bank_inc = len(dlg1_def['text'])
    for index, offset in enumerate(item_offsets):
        if offset >= 0x010000:
            bank_inc = index
            break

    # split the two dialogue banks
    dlg2_def['text'] = dlg1_def['text'][bank_inc:]
    dlg1_def['text'] = dlg1_def['text'][:bank_inc]


def combine_dlg(dlg1_def, dlg2_def):
    # put all the dialogue strings into the first bank
    dlg1_def['text'] += dlg2_def['text']
    dlg2_def['text'] = []


if __name__ == '__main__':
    dlg_cmd = sys.argv[1]
    lang_suffix = sys.argv[2]
    dlg1_path = os.path.join('src', 'text', f'dlg1_{lang_suffix}.json')
    dlg2_path = os.path.join('src', 'text', f'dlg2_{lang_suffix}.json')
    dlg1_dat_path = os.path.join('src', 'text', f'dlg1_{lang_suffix}.dat')
    dlg2_dat_path = os.path.join('src', 'text', f'dlg2_{lang_suffix}.dat')

    if not (os.path.exists(dlg1_path) and os.path.exists(dlg2_path)):
        exit(0)

    # read both dialogue json files
    with open(dlg1_path, 'r') as dlg1_file, open(dlg2_path, 'r') as dlg2_file:
        dlg1_def = json.load(dlg1_file)
        dlg2_def = json.load(dlg2_file)

    # split or combine the dialogue entries
    if dlg_cmd == 'split':
        split_dlg(dlg1_def, dlg2_def)

    elif dlg_cmd == 'combine':
        combine_dlg(dlg1_def, dlg2_def)

        # encoded dialogue data does not need to be updated after combining
        os.utime(dlg1_dat_path)
        os.utime(dlg2_dat_path)

    else:
        raise ValueError('Invalid command:', dlg_cmd)

    # save both dialogue json files
    with open(dlg1_path, 'w') as dlg1_file, open(dlg2_path, 'w') as dlg2_file:
        dlg1_file.write(json.dumps(dlg1_def, ensure_ascii=False, indent=2))
        dlg2_file.write(json.dumps(dlg2_def, ensure_ascii=False, indent=2))
