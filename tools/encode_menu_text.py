#!/usr/bin/env python3

import re
import os
import sys
import romtools as rt

SMALL_CHAR_TABLES_EN = [
    'null_terminated_en',
    'text_en',
    'small_symbols_en'
]

BIG_CHAR_TABLES_EN = [
    'null_terminated_en',
    'text_en',
    'big_symbols_en'
]

SMALL_CHAR_TABLES_JP = [
    'null_terminated_jp',
    'kana',
    'small_symbols_jp'
]

BIG_CHAR_TABLES_JP = [
    'null_terminated_jp',
    'kana',
    'big_symbols_jp',
    'kanji'
]

ROMAJI_CHAR_TABLES_JP = [
    'null_terminated_jp',
    'romaji',
    'small_symbols_jp'
]

if __name__ == '__main__':
    src_path = sys.argv[1]
    inc_path = src_path + '.raw'

    # create the menu text codec
    if src_path.endswith('en.inc'):
        codec_big = rt.TextCodec({'char_tables': BIG_CHAR_TABLES_EN})
        codec_small = rt.TextCodec({'char_tables': SMALL_CHAR_TABLES_EN})
    else:
        codec_big = rt.TextCodec({'char_tables': BIG_CHAR_TABLES_JP})
        codec_small = rt.TextCodec({'char_tables': SMALL_CHAR_TABLES_JP})
        codec_romaji = rt.TextCodec({'char_tables': ROMAJI_CHAR_TABLES_JP})

    # read asset file
    with open(src_path, 'r', encoding='utf8') as src_file:
        src_lines = src_file.readlines()

    dest_text = ''

    for src_line in src_lines:
        match_text = re.search(r'([zbr]*)?\"([^\"\n]+)\"', src_line)
        if not match_text:
            dest_text += src_line
            continue
        match_start, match_end = match_text.span()

        if match_text.group(1).find('b') != -1:
            # use large font codec
            encoded_bytes = codec_big.encode(match_text.group(2))
        elif match_text.group(1).find('r') != -1:
            # use romaji font codec
            encoded_bytes = codec_romaji.encode(match_text.group(2))
        else:
            # use small font codec
            encoded_bytes = codec_small.encode(match_text.group(2))

        if match_text.group(1).find('z') != -1:
            # remove the null-terminator
            encoded_bytes = encoded_bytes[:-1]
        encoded_values = [('$%02x' % x) for x in encoded_bytes]
        replacement = ','.join(encoded_values)

        dest_text += src_line[:match_start]
        dest_text += replacement
        dest_text += src_line[match_end:-1]
        dest_text += '  ; ' + match_text.group(2) + '\n'

    # write the encoded assembly data to the dest path
    with open(inc_path, 'w') as f:
        f.write(dest_text)
