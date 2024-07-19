#!/usr/bin/env python3

import os
import binascii
import json
import romtools as rt
from ff6_lzss import *
from monster_stencil import apply_stencil

def extract_rom(rom_bytes, language):

    ae = rt.AssetExtractor(rom_bytes, 'hirom')

    # load rip info
    rip_list_path = os.path.join('tools', f'rip_list_{language}.json')
    with open(rip_list_path, 'r', encoding='utf8') as rip_list_file:
        rip_list = json.load(rip_list_file)

    # extract text
    for text in rip_list['text']:
        ae.extract_text(**text)

    # extract data
    for data in rip_list['data']:
        ae.extract_asset(**data)

    # extract arrays
    for arr in rip_list['array']:
        ae.extract_array(**arr)

    # apply monster graphics stencils
    monster_gfx_dir = os.path.join('src', 'gfx', 'monster_gfx')
    os.makedirs(monster_gfx_dir, exist_ok=True)
    for trimmed_filename in os.listdir(monster_gfx_dir):
        if not trimmed_filename.endswith('.trm'):
            continue
        trimmed_path = os.path.join(monster_gfx_dir, trimmed_filename)

        # check if the full monster graphics already exists
        gfx_path, _ = os.path.splitext(trimmed_path)
        if os.path.exists(gfx_path):
            continue

        stencil_path = os.path.splitext(gfx_path)[0] + '.stn'

        # read the trimmed graphics and the stencil
        with open(trimmed_path, 'rb') as trimmed_gfx_file:
            trimmed_gfx = trimmed_gfx_file.read()
        with open(stencil_path, 'rb') as stencil_file:
            stencil_bytes = stencil_file.read()

        # apply the stencil to the trimmed graphics
        if gfx_path.endswith('3bpp'):
            gfx_bytes = apply_stencil(trimmed_gfx, stencil_bytes, 24)
        elif gfx_path.endswith('4bpp'):
            gfx_bytes = apply_stencil(trimmed_gfx, stencil_bytes, 32)
        else:
            raise Exception('Invalid monster graphics:', gfx_path)

        # write the full monster graphics file
        with open(gfx_path, 'wb') as gfx_file:
            gfx_file.write(gfx_bytes)

        # update the accessed and modified timestamps for the trimmed file
        os.utime(trimmed_path)


if __name__ == '__main__':
    memory_map = rt.MemoryMap('hirom')

    # search the vanilla directory for valid ROM files
    dir_list = os.listdir('vanilla')

    found_one = False
    for file_name in dir_list:

        # skip directory names
        if os.path.isdir(file_name):
            continue
        file_path = os.path.join('vanilla', file_name)

        # read the file and calculate its CRC32
        with open(file_path, 'rb') as file:
            file_bytes = bytearray(file.read())
        crc32 = binascii.crc32(file_bytes) & 0xFFFFFFFF

        if crc32 == 0x45EF5AC8:
            rom_name = 'Final Fantasy VI 1.0 (J)'
            rom_language = 'jp'
        elif crc32 == 0xA27F1C7A:
            rom_name = 'Final Fantasy III 1.0 (U)'
            rom_language = 'en'
        elif crc32 == 0xC0FA0464:
            rom_name = 'Final Fantasy III 1.1 (U)'
            rom_language = 'en'
        else:
            continue

        print(f'Found ROM: {rom_name}')
        print(f'File: {file_path}')
        found_one = True

        extract_rom(file_bytes, rom_language)

    if not found_one:
        print('No valid ROM files found!\nPlease copy your valid FF6 ROM ' +
              'file(s) into the "vanilla" directory.\nIf your ROM has a ' +
              '512-byte copier header, please remove it first.')
