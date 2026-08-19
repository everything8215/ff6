#!/usr/bin/env python3

import os
import sys
import romtools as rt


codec = rt.TextCodec()
str_list = []
enum_list = []
str_index = -1
is_sequential = False

def parse_cmd(cmd_line):

    global str_index, is_sequential

    # parse the command
    command, _, param = cmd_line.partition(':')

    if command == '#char_tbl':
        # add a character table
        codec.load_char_table(f'tools/char_table/{param}.json')

    elif command == '#item_size':
        # set the item size
        codec.item_size = int(param)

    elif command == '#is_sequential':
        # set the item size
        is_sequential = True

    elif command == '#text':
        # start a new string
        str_index += 1
        enum_list.append(param)
        str_list.append('')

    else:
        raise ValueError('Invalid preprocessor command:', command)


if __name__ == '__main__':

    asset_path = sys.argv[1]
    dat_path = sys.argv[2]

    # read asset file
    with open(asset_path, 'r', encoding='utf8') as asset_file:
        asset_lines = asset_file.readlines()

    for line in asset_lines:

        line = line.rstrip('\r\n')

        # parse preprocessor commands
        if line.startswith('#'):
            parse_cmd(line)

        elif str_index >= 0:
            str_list[str_index] += line

    # encode each string
    item_list = [codec.encode(item) for item in str_list]

    # condense the array and generate a pointer table
    encoded_bytes, item_ranges = rt.condense_array(item_list,
                                                   item_size=codec.item_size,
                                                   is_sequential=is_sequential)

    # write ptr file
    ptr_path = os.path.splitext(dat_path)[0] + '.ptr'
    os.makedirs(os.path.dirname(ptr_path), exist_ok=True)
    with open(ptr_path, 'w') as f:

        # write metadata
        f.write('SIZE = %d\n' % len(encoded_bytes))
        f.write('COUNT = %d\n' % len(item_list))
        f.write('ITEM_SIZE = %d\n' % codec.item_size)

        # write string offsets
        for i, str_range in enumerate(item_ranges):
            f.write('_%d = %d\n' % (i, str_range.begin))

        # write string enum values
        for i in range(len(item_list)):
            if enum_list[i]:
                f.write('%s = %d\n' % (enum_list[i], i))

    # write the encoded binary data to the data path
    with open(dat_path, 'wb') as f:
        f.write(encoded_bytes)
