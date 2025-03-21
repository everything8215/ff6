#!/usr/bin/env python3

import romtools as rt
import os
import re
import sys
import json

ESCAPE_REGEX = r'{(\w+)(?:\:(\w+))?}'

def escape_len(code):
    param_match = re.match(ESCAPE_REGEX, code)
    if param_match is None or param_match.group(2) == None:
        return 1
    elif param_match.group(2) == 'b':
        return 2
    elif param_match.group(2) == 'w':
        return 3
    else:
        return 1


def optimize_dte(dlg_def):

    # make sure there is a DTE table
    char_tables = dlg_def['char_tables']
    if 'dte' not in char_tables:
        print("Can't optimize DTE")
        return

    # create a text codec without DTE
    char_tables.remove('dte')
    dlg_def['char_tables'] = char_tables

    # encode all of the dialogue
    dlg_bytes, _ = rt.encode_text(dlg_def)

    # find all valid pairs of characters
    text_codec = rt.TextCodec(dlg_def)
    dte_pairs = {}

    i = 0
    while i < len(dlg_bytes) - 2:
        first_code = dlg_bytes[i]
        first_char = text_codec.decoding_table[first_code]
        if first_char[0] == '{':
            i += escape_len(first_char)
            continue

        second_code = dlg_bytes[i + 1]
        second_char = text_codec.decoding_table[second_code]
        if second_char[0] == '{':
            i += escape_len(second_char) + 1
            continue

        pair = first_char + second_char
        i += 2

        if pair in dte_pairs:
            dte_pairs[pair] += 1
        else:
            dte_pairs[pair] = 1

    # choose the 128 most common pairs
    sorted_pairs = sorted(dte_pairs.items(), key=lambda pair: pair[1], reverse=True)

    dte_char_table = {}
    print('Most common char pairs:')
    for i in range(128):
        pair = sorted_pairs[i]
        dte_char_table[rt.hex_string(i + 128)] = pair[0]
        print(pair[0], pair[1])

    # update the dte char table
    dte_char_table_path = os.path.join('tools', 'char_table', 'dte.json')
    with open(dte_char_table_path, 'w') as dte_char_table_file:
        dte_char_table_file.write(json.dumps(dte_char_table, ensure_ascii=False, indent=2))

    # update the dte text file
    dte_list = [item[0] for item in sorted_pairs[:128]]
    dte_json_path = os.path.join('src', 'text', 'dte_tbl_en.json')
    with open(dte_json_path, 'r', encoding='utf8') as dte_json_file:
        dte_json = json.load(dte_json_file)
        dte_json['text'] = dte_list
    with open(dte_json_path, 'w', encoding='utf8') as dte_json_file:
        dte_json_file.write(json.dumps(dte_json, ensure_ascii=False, indent=2))


def split_dlg(dlg1_def, dlg2_def):

    # find the first dialog offset beyond the first bank
    _, item_ranges = rt.encode_text(dlg1_def)
    bank_inc = len(dlg1_def['text'])
    for index, range in enumerate(item_ranges):
        if range.begin >= 0x010000:
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

    if not (os.path.exists(dlg1_path) and os.path.exists(dlg2_path)):
        exit(0)

    # read both dialogue json files
    with open(dlg1_path, 'r', encoding='utf8') as dlg1_file, open(dlg2_path, 'r', encoding='utf8') as dlg2_file:
        dlg1_def = json.load(dlg1_file)
        dlg2_def = json.load(dlg2_file)

    # split or combine the dialogue entries
    if dlg_cmd == 'split':
        split_dlg(dlg1_def, dlg2_def)

        # save both dialogue json files
        with open(dlg1_path, 'w', encoding='utf8') as dlg1_file, open(dlg2_path, 'w', encoding='utf8') as dlg2_file:
            dlg1_file.write(json.dumps(dlg1_def, ensure_ascii=False, indent=2))
            dlg2_file.write(json.dumps(dlg2_def, ensure_ascii=False, indent=2))

    elif dlg_cmd == 'combine':
        dlg1_dat_path = os.path.join('src', 'text', f'dlg1_{lang_suffix}.dat')
        dlg2_dat_path = os.path.join('src', 'text', f'dlg2_{lang_suffix}.dat')
        if not (os.path.exists(dlg1_dat_path) and os.path.exists(dlg2_dat_path)):
            exit(0)

        combine_dlg(dlg1_def, dlg2_def)

        # save both dialogue json files
        with open(dlg1_path, 'w', encoding='utf8') as dlg1_file, open(dlg2_path, 'w', encoding='utf8') as dlg2_file:
            dlg1_file.write(json.dumps(dlg1_def, ensure_ascii=False, indent=2))
            dlg2_file.write(json.dumps(dlg2_def, ensure_ascii=False, indent=2))

        # encoded dialogue data does not need to be updated after combining
        os.utime(dlg1_dat_path)
        os.utime(dlg2_dat_path)

    elif dlg_cmd == 'dte':
        optimize_dte(dlg1_def)
        os.utime(dlg1_path)
        os.utime(dlg2_path)

    else:
        raise ValueError('Invalid command:', dlg_cmd)

