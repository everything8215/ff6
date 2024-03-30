#!/usr/bin/env python3

import json
import os
import sys
import romtools as rt

def encode_text(asset_def):

    # create the text codec
    char_table = {}
    for char_table_name in asset_def['char_tables']:
        char_table_path = os.path.join('tools', 'char_table', char_table_name + '.json')
        with open(char_table_path, 'r') as char_table_file:
            char_table.update(json.load(char_table_file))
    text_codec = rt.TextCodec(char_table)

    # encode each string
    encoded_bytes = bytearray()
    item_offsets = []
    for text_item in asset_def['text']:
        encoded_text = text_codec.encode_text(text_item)

        if 'item_size' in asset_def:
            # fixed length strings
            item_size = asset_def['item_size']

            # check if text is too long
            assert len(encoded_text) <= item_size, \
                f'Text string \"{text_item}\" too long by ' \
                f'{len(encoded_text) - item_size} char(s)'

            # pad the text
            if len(encoded_text) != item_size:
                assert '{pad}' in text_codec.encoding_table, \
                    f'Padding not found in char table'
                pad_char = text_codec.encoding_table['{pad}']
                item_size = asset_def['item_size']
                while len(encoded_text) < item_size:
                    encoded_text.append(pad_char)

            item_offsets.append(len(encoded_bytes))
            encoded_bytes += encoded_text

        elif 'is_sequential' in asset_def:
            # items must be sequential, don't allow shared items
            item_offsets.append(len(encoded_bytes))
            encoded_bytes += encoded_text

        else:
            # allow shared items
            shared_offset = encoded_bytes.find(encoded_text)
            if shared_offset == -1:
                item_offsets.append(len(encoded_bytes))
                encoded_bytes += encoded_text
            else:
                item_offsets.append(shared_offset)

    return item_offsets, encoded_bytes


def update_text_inc(asset_def, item_offsets):

    asset_label = asset_def['asset_label']
    asset_const = asset_def['asset_const']

    # define the array length
    inc_text = f'{asset_const}_ARRAY_LENGTH = {len(item_offsets)}\n'

    if 'item_size' in asset_def:
        # fixed item size
        inc_text += f'{asset_const}_SIZE = '
        inc_text += str(asset_def['item_size']) + '\n'
    else:
        # define item offsets
        inc_text += '\n'
        for id, offset in enumerate(item_offsets):
            inc_text += f'{asset_label}_%04x := ' % id
            inc_text += f'{asset_label} + $%04x\n' % offset

    # update item offsets in the include file
    rt.insert_asm(asset_def['inc_path'], inc_text)


if __name__ == '__main__':

    asset_path = sys.argv[1]

    # read asset file
    with open(asset_path, 'r') as json_file:
        asset_def = json.load(json_file)

    item_offsets, encoded_bytes = encode_text(asset_def)

    # write the encoded binary data to the data path
    asset_root, _ = os.path.splitext(asset_path)
    dat_path = asset_root + '.dat'
    with open(dat_path, 'wb') as f:
        f.write(encoded_bytes)

    # if necessary, update the offsets in the include file
    if 'inc_path' in asset_def:
        update_text_inc(asset_def, item_offsets)
