#!/usr/bin/env python3

import json
import glob
import os
import romtools as rt

def clean_assets(rip_list):
    # remove text strings from all json files
    for text_def in rip_list['text']:
        json_path = text_def['json_path']
        with open(json_path, 'r', encoding='utf8') as f:
            text_def = json.load(f)

        # clear auto-generated code in the include file
        if 'inc_path' in text_def:
            inc_path = text_def['inc_path']
            rt.insert_asm(inc_path, '')

        # clear the text array
        text_def['text'] = []

        # write back to the json file
        asset_json = json.dumps(text_def, ensure_ascii=False, indent=2)
        with open(json_path, 'w', encoding='utf8') as f:
            f.write(asset_json)

        # delete the binary text file
        asset_root, _ = os.path.splitext(json_path)
        if os.path.exists(asset_root + '.dat'):
            os.remove(asset_root + '.dat')

    # remove data assets
    for data_def in rip_list['data'] + rip_list['array']:
        file_path = data_def['file_path']
        if '%s' in file_path:
            file_path = file_path.replace('%s', '*')

        for asset_path in glob.glob(file_path):
            if os.path.exists(asset_path):
                os.remove(asset_path)
            if asset_path.endswith('.lz') and os.path.exists(asset_path[:-3]):
                # remove uncompressed asset files
                os.remove(asset_path[:-3])
            elif asset_path.endswith('.trm') and os.path.exists(asset_path[:-4]):
                # remove trimmed monster graphics files
                os.remove(asset_path[:-4])

        if 'inc_path' in data_def:
            rt.insert_asm(data_def['inc_path'], '')


if __name__ == '__main__':

    # read both rip lists
    for rip_list_path in ['tools/rip_list_en.json', 'tools/rip_list_jp.json']:
        with open(rip_list_path, 'r', encoding='utf8') as f:
            rip_list = json.load(f)
        clean_assets(rip_list)

