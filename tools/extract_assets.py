#!/usr/bin/env python3

import os
import binascii
import json
import romtools as rt
from ff6_lzss import *
from monster_stencil import apply_stencil

rom_language = 'en'


def make_build_path(asset_path):

    # pull out the localization suffix if present (no effect if not)
    build_path, file_ext = os.path.splitext(asset_path)
    build_path, asset_lang = os.path.splitext(build_path)
    build_path += file_ext

    if build_path.startswith('build'):
        return build_path, asset_lang
    else:
        return os.path.join('build', rom_language, build_path), asset_lang


def write_asset_file(asset_bytes, asset_path, format=None):

    # decompress the data, if needed
    if format == 'lz':
        raw_bytes = decode_lzss(asset_bytes)
    elif format == 'stc':
        raw_bytes = apply_monster_stencil(asset_bytes, asset_path)
    else:
        raw_bytes = asset_bytes

    # save the raw data as specified
    if not os.path.exists(asset_path):
        os.makedirs(os.path.dirname(asset_path), exist_ok=True)
        with open(asset_path, 'wb') as f:
            f.write(raw_bytes)

    if format is None:
        return

    # create paths to the build directory
    raw_build_path, asset_lang = make_build_path(asset_path)
    build_path = raw_build_path + '.' + format

    # if localized, save the raw data to build directory
    if asset_lang and not os.path.exists(raw_build_path):
        os.makedirs(os.path.dirname(raw_build_path), exist_ok=True)
        with open(raw_build_path, 'wb') as f:
            f.write(raw_bytes)

    # save the compressed data to build directory
    if not os.path.exists(build_path):
        os.makedirs(os.path.dirname(build_path), exist_ok=True)
        with open(build_path, 'wb') as f:
            f.write(asset_bytes)


def extract_text(ae, text_def):

    # read the json file
    assert 'asset_path' in text_def, 'asset_path not found'
    asset_path = text_def['asset_path']

    # pull out the localization suffix if present (no effect if not)
    build_path, _ = make_build_path(asset_path)

    # generate the dat file path from the json file path
    dat_path, _ = os.path.splitext(build_path)
    dat_path += '.bin'

    # check if the data file already exists and is not empty
    if os.path.exists(dat_path) and os.stat(dat_path).st_size != 0:
        return

    # otherwise, we need to extract the text and create the data file
    assert 'asset_range' in text_def, 'asset_range not found'
    asset_range = text_def['asset_range']
    print(f'{asset_range} -> {asset_path}')

    # extract the text from the ROM
    asset_bytes, item_ranges = ae.extract_asset(**text_def)

    # read asset file
    with open(asset_path, 'r', encoding='utf8') as asset_file:
        asset_lines = asset_file.readlines()

    # create the text codec
    text_codec = rt.TextCodec()
    is_sequential = False
    enum_list = []
    str_index = -1

    dest_text = ''

    for line in asset_lines:

        # remove newline
        line = line.rstrip('\r\n')

        # parse preprocessor commands
        if line.startswith('#'):

            # parse the command
            full_command = line.split(maxsplit=1)[0]
            dest_text += full_command + '\n'
            command, _, param = full_command.partition(':')

            if command == '#char_tbl':
                # add a character table
                text_codec.load_char_table(f'tools/char_table/{param}.json')

            elif command == '#item_size':
                # set the item size
                text_codec.item_size = int(param)

            elif command == '#is_sequential':
                # set the item size
                is_sequential = True

            elif command == '#text':
                # start a new string
                str_index += 1
                enum_list.append(param)

                # decode and print the string
                item_range = item_ranges[str_index]
                item_bytes = asset_bytes[item_range.begin:item_range.end + 1]
                str_text = text_codec.decode(item_bytes)
                str_text = str_text.replace('{n}', '{n}\n')
                str_text = str_text.replace('{page}', '{page}\n')
                dest_text += str_text
                while not dest_text.endswith('\n\n'):
                    dest_text += '\n'

            else:
                raise ValueError('Invalid preprocessor command:', command)

        elif str_index < 0:
            dest_text += line + '\n'


    # write array metadata and string offsets
    ptr_path = os.path.splitext(dat_path)[0] + '.ptr'
    os.makedirs(os.path.dirname(ptr_path), exist_ok=True)
    with open(ptr_path, 'w') as f:

        # write metadata
        f.write('SIZE = %d\n' % len(asset_bytes))
        f.write('COUNT = %d\n' % len(item_ranges))
        f.write('ITEM_SIZE = %d\n' % text_codec.item_size)

        # write string offsets
        for i, item_range in enumerate(item_ranges):
            f.write('_%d = %d\n' % (i, item_range.begin))

        # write string enum values
        for i in range(len(item_ranges)):
            if enum_list[i]:
                f.write('%s = %d\n' % (enum_list[i], i))

    # write text strings to the asset file
    with open(asset_path, 'w', encoding='utf8') as f:
        f.write(dest_text)

    # write data file
    write_asset_file(asset_bytes, dat_path)


# def extract_text(ae, text_def):

#     # read the json file
#     assert 'asset_path' in text_def, 'asset_path not found'
#     asset_path = text_def['asset_path']

#     # pull out the localization suffix if present (no effect if not)
#     build_path, _ = make_build_path(asset_path)

#     # generate the dat file path from the json file path
#     dat_path, _ = os.path.splitext(build_path)
#     dat_path += '.dat'

#     # check if the data file already exists and is not empty
#     if os.path.exists(dat_path) and os.stat(dat_path).st_size != 0:
#         return

#     # otherwise, we need to extract the text and create the data file
#     assert 'asset_range' in text_def, 'asset_range not found'
#     asset_range = text_def['asset_range']
#     print(f'{asset_range} -> {asset_path}')

#     # read asset file
#     with open(asset_path, 'r', encoding='utf8') as json_file:
#         asset_def = json.load(json_file)

#     # # for fixed-length text strings, copy the item length to text_def
#     # if 'item_size' in asset_def:
#     #     text_def['item_size'] = asset_def['item_size']

#     # if 'is_sequential' in asset_def:
#     #     text_def['is_sequential'] = asset_def['is_sequential']

#     # extract the text from the ROM
#     asset_bytes, item_ranges = ae.extract_asset(**text_def)

#     # create the text codec
#     text_codec = rt.TextCodec()
#     if 'item_size' in asset_def:
#         text_codec.item_size = asset_def['item_size']
#     for char_table in asset_def['char_tables']:
#         text_codec.load_char_table(f'tools/char_table/{char_table}.json')

#     # write array metadata and string offsets
#     ptr_path = os.path.splitext(dat_path)[0] + '.ptr'
#     os.makedirs(os.path.dirname(ptr_path), exist_ok=True)
#     with open(ptr_path, 'w') as f:
#         f.write('SIZE = %d\n' % len(asset_bytes))
#         f.write('COUNT = %d\n' % len(item_ranges))
#         f.write('ITEM_SIZE = %d\n' % text_codec.item_size)

#         # array item offsets
#         for i, range in enumerate(item_ranges):
#             f.write('_%d = %d\n' % (i, range.begin))

#     # decode the text strings
#     text_list = []
#     for item_range in item_ranges:
#         item_bytes = asset_bytes[item_range.begin:item_range.end + 1]
#         text_list.append(text_codec.decode(item_bytes))

#     asset_def['text'] = text_list

#     # write text strings to the asset file
#     asset_json = json.dumps(asset_def, ensure_ascii=False, indent=2)
#     with open(asset_path, 'w', encoding='utf8') as f:
#         f.write(asset_json)

#     # write data file
#     write_asset_file(asset_bytes, dat_path)


def extract_data(ae, data_def):

    # extract the asset from the ROM
    asset_bytes, item_ranges = ae.extract_asset(**data_def)

    # generate a list of file names
    assert 'asset_path' in data_def, 'asset_path not found'
    asset_path = data_def['asset_path']
    if 'file_list' in data_def:
        file_list = data_def['file_list']
        assert len(file_list) == len(item_ranges), 'array length mismatch'
    else:
        file_list = [('%04x' % i) for i in range(len(item_ranges))]
    path_list = [
        asset_path.replace('%s', file_list[i])
        for i in range(len(item_ranges))
    ]

    assert 'asset_range' in data_def, 'asset_range not found'
    asset_range = data_def['asset_range']
    extracted_one = False
    format = data_def.get('format')
    for i, item_range in enumerate(item_ranges):
        # if os.path.exists(path_list[i]):
        #     continue
        if item_range.is_empty() or item_range.begin < 0:
            continue
        if not extracted_one:
            extracted_one = True
            print(f'{asset_range} -> {asset_path}')
        data_bytes = asset_bytes[item_range.begin:item_range.end + 1]
        write_asset_file(data_bytes, path_list[i], format)


def extract_array(ae, array_def):

    # extract the array data from the ROM
    asset_bytes, item_ranges = ae.extract_asset(**array_def)

    assert 'asset_path' in array_def, 'asset_path not found'
    asset_path = array_def['asset_path']

    # write data file
    assert 'asset_range' in array_def, 'asset_range not found'
    asset_range = array_def['asset_range']
    print(f'{asset_range} -> {asset_path}')
    if not os.path.exists(asset_path):
        write_asset_file(asset_bytes, asset_path, array_def.get('format'))

    # write metadata and pointer offsets to ptr file
    ptr_path, _ = os.path.splitext(asset_path)
    ptr_path += '.ptr'
    if not os.path.exists(ptr_path):
        os.makedirs(os.path.dirname(ptr_path), exist_ok=True)
        with open(ptr_path, 'w') as f:
            f.write('SIZE = %d\n' % len(asset_bytes))
            f.write('COUNT = %d\n' % len(item_ranges))
            f.write('ITEM_SIZE = 0\n')

            # array item offsets
            for i, range in enumerate(item_ranges):
                f.write('_%d = %d\n' % (i, range.begin))


def apply_monster_stencil(trimmed_gfx, asset_path):

    # remove localization suffix and generate the stencil path
    stencil_path = os.path.join('build', rom_language, asset_path)
    stencil_path, file_ext = os.path.splitext(stencil_path)
    stencil_path, _ = os.path.splitext(stencil_path)
    stencil_path += file_ext + '.stn'

    # read the stencil
    with open(stencil_path, 'rb') as stencil_file:
        stencil_bytes = stencil_file.read()

    # determine the tile size based on the file extension
    if asset_path.endswith('3bpp'):
        tile_size = 24
    elif asset_path.endswith('4bpp'):
        tile_size = 32
    else:
        raise Exception('Invalid monster graphics:', asset_path)

    # apply the stencil to the trimmed graphics
    gfx_bytes = apply_stencil(trimmed_gfx, stencil_bytes, tile_size)

    return gfx_bytes


if __name__ == '__main__':

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

        # load rip info
        rip_list_path = os.path.join('tools', f'rip_list_{rom_language}.json')
        with open(rip_list_path, 'r', encoding='utf8') as rip_list_file:
            rip_list = json.load(rip_list_file)

        ae = rt.AssetExtractor(file_bytes, 'hirom')
        [extract_text(ae, text_def) for text_def in rip_list['text']]
        # [extract_text_new(ae, text_def) for text_def in rip_list['text_new']]
        [extract_data(ae, data_def) for data_def in rip_list['data']]
        [extract_array(ae, array_def) for array_def in rip_list['array']]

    if not found_one:
        print('No valid ROM files found!')
        print('Please copy your valid FF6 ROM file(s) into the ' +
              '"vanilla" directory.')
        print('If your ROM has a 512-byte copier header, please remove it ' +
              'first.')
