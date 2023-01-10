#!/usr/bin/env python3

import os
import binascii
import json
import romtools as rt

ff6_rom_info_list = {
    # 0x45EF5AC8: {
    #     'name': 'Final Fantasy VI 1.0 (J)',
    #     'extractPath': 'vanilla/ff6-jp-extract.json',
    #     'cutscenePath': 'assets/cutscene_jp.lz',
    #     'cutsceneRange': '0xC2686C-0xC28A51',
    # },
    0xA27F1C7A: {
        'name': 'Final Fantasy III 1.0 (U)',
        'extractPath': 'vanilla/ff6-en-extract.json',
        'cutscenePath': 'assets/cutscene_en.lz',
        'cutsceneRange': '0xC2686C-0xC28A5F',
    },
    0xC0FA0464: {
        'name': 'Final Fantasy III 1.1 (U)',
        'extractPath': 'vanilla/ff6-en-extract.json',
        'cutscenePath': 'assets/cutscene_en.lz',
        'cutsceneRange': '0xC2686C-0xC28A5F',
    }
}

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
    if not crc32 in ff6_rom_info_list:
        continue

    # print ROM info
    rom_info = ff6_rom_info_list[crc32]
    rom_name = rom_info['name']
    print(f'Found ROM: {rom_name}')
    print(f'File: {file_path}')
    found_one = True

    # load the definition file
    extract_path = rom_info['extractPath']
    with open(extract_path, 'r') as extract_file:
        extract_definition = json.load(extract_file)

    # create the asset extractor
    map_mode = extract_definition['mode']
    extractor = rt.AssetExtractor(map_mode)

    # extract the list of assets
    asset_list = extract_definition['assets']
    for asset_definition in asset_list:
        if 'key' not in asset_definition:
            continue
        extractor.extract_asset(file_data, asset_definition)

    # copy the compressed cutscene program
    cutscene_range = rt.Range(rom_info['cutsceneRange'])
    cutscene_path = rom_info['cutscenePath']
    print(f'{cutscene_range} CutsceneProgram -> {cutscene_path}')
    cutscene_range = extractor.memory_map.map_range(cutscene_range)
    cutscene_data = file_data[cutscene_range.begin:cutscene_range.end + 1]

    # write the compressed cutscene program to a file
    os.makedirs(os.path.dirname(cutscene_path), exist_ok=True)
    with open(cutscene_path, 'wb') as cutscene_file:
        cutscene_file.write(cutscene_data)

if not found_one:
    print('No valid ROM files found!\nPlease copy your valid FF6 ROM ' +
          'file(s) into the "vanilla" directory.\nIf your ROM has a header, ' +
          'please remove it first.')
