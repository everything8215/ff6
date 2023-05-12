#!/usr/bin/env python3

import os
import binascii
import json
import romtools as rt
from ff6_lzss import *

rt.DataCodec.add_format('ff6-lzss', encode_lzss, decode_lzss)

ff6_rom_info_list = {
    # 0x45EF5AC8: {
    #     'name': 'Final Fantasy VI 1.0 (J)',
    #     'assetList': 'tools/ff6_jp_asset_list.json',
    #     'cutscenePath': 'assets/cutscene/cutscene_jp.lz',
    #     'cutsceneRange': '0xC2686C-0xC28A51',
    # },
    0xA27F1C7A: {
        'name': 'Final Fantasy III 1.0 (U)',
        'assetList': 'tools/ff6_en_asset_list.json',
        'cutscenePath': 'assets/cutscene/cutscene_en.lz',
        'cutsceneRange': '0xC2686C-0xC28A5F',
    },
    0xC0FA0464: {
        'name': 'Final Fantasy III 1.1 (U)',
        'assetList': 'tools/ff6_en_asset_list.json',
        'cutscenePath': 'assets/cutscene/cutscene_en.lz',
        'cutsceneRange': '0xC2686C-0xC28A5F',
    }
}

asset_manager = rt.AssetManager()

# search the vanilla directory for valid ROM files
dir_list = os.listdir('vanilla')

found_one = False
for file_name in dir_list:

    # skip directory names
    if os.path.isdir(file_name):
        continue
    file_path = 'vanilla/' + file_name

    # read the file and calculate its CRC32
    with open(file_path, 'rb') as file:
        file_data = bytearray(file.read())
    crc32 = binascii.crc32(file_data) & 0xFFFFFFFF

    # skip files that are not valid vanilla ROMs
    if crc32 not in ff6_rom_info_list:
        continue

    # print ROM info
    rom_info = ff6_rom_info_list[crc32]
    rom_name = rom_info['name']
    print(f'Found ROM: {rom_name}')
    print(f'File: {file_path}')
    found_one = True

    memory_map = rt.MemoryMap('hirom')

    # load the asset extraction info
    asset_list_path = rom_info['assetList']
    with open(asset_list_path, 'r') as asset_list_file:
        asset_list = json.load(asset_list_file)

    # extract the list of assets
    for asset_key in asset_list:
        asset_manager.extract_asset(asset_key, file_data, memory_map)

    # copy the compressed cutscene program
    cutscene_range = rt.Range(rom_info['cutsceneRange'])
    cutscene_path = rom_info['cutscenePath']
    print(f'{cutscene_range} CutsceneProgram -> {cutscene_path}')
    cutscene_range = memory_map.map_range(cutscene_range)
    cutscene_data = file_data[cutscene_range.begin:cutscene_range.end + 1]

    # write the compressed cutscene program to a file
    os.makedirs(os.path.dirname(cutscene_path), exist_ok=True)
    with open(cutscene_path, 'wb') as cutscene_file:
        cutscene_file.write(cutscene_data)

if not found_one:
    print('No valid ROM files found!\nPlease copy your valid FF6 ROM ' +
          'file(s) into the "vanilla" directory.\nIf your ROM has a header, ' +
          'please remove it first.')
