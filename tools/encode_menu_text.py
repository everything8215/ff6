#!/usr/bin/env python3

import re
import sys
import romtools as rt

codecs = {}

def parse_cmd(cmd_line):

    tokens = cmd_line.split()
    command = tokens[0]

    if command == '#codec':

        # create a new text codec
        new_codec = rt.TextCodec()

        # save in the list of codecs, and mark as current
        if not codecs:
            # mark as default if this is the first codec found
            codecs['default'] = new_codec
        codecs[tokens[1]] = new_codec
        codecs['current'] = new_codec

    elif command == '#char_table':
        if 'current' not in codecs:
            raise ValueError('No active codec')

        codecs['current'].load_char_table(f'tools/char_table/{tokens[1]}.json')

    elif command == '#item_size':
        if 'current' not in codecs:
            raise ValueError('No active codec')

        codecs['current'].item_size = int(tokens[1])

    else:
        raise ValueError('Invalid preprocessor command:', command)


if __name__ == '__main__':
    src_path = sys.argv[1]
    inc_path = sys.argv[2]

    # read asset file
    with open(src_path, 'r', encoding='utf8') as src_file:
        src_lines = src_file.readlines()

    dest_text = ''

    for src_line in src_lines:

        # parse preprocessor commands
        if src_line.startswith('#'):
            dest_text += '; ' + src_line
            parse_cmd(src_line)
            continue

        match_text = re.search(r'([a-z_]*)?\"([^\"\n]*)\"', src_line)
        if not match_text:
            dest_text += src_line
            continue

        match_start, match_end = match_text.span()

        if match_text.group(1) in codecs:
            codec_id = match_text.group(1)
            encoded_bytes = codecs[codec_id].encode(match_text.group(2))

        elif not match_text.group(1):
            assert 'default' in codecs, 'No text codecs'
            encoded_bytes = codecs['default'].encode(match_text.group(2))

        else:
            raise ValueError(f'Unknown codec id: {match_text.group(1)}')

        encoded_values = [('$%02x' % x) for x in encoded_bytes]
        replacement = ','.join(encoded_values)

        dest_text += src_line[:match_start]
        dest_text += replacement
        dest_text += src_line[match_end:-1]
        dest_text += '  ; ' + match_text.group(0) + '\n'

    # write the encoded assembly data to the dest path
    with open(inc_path, 'w') as f:
        f.write(dest_text)
