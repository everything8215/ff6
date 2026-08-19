#!/usr/bin/env python3

import sys, glob


def clean_text(text_path):
    with open(text_path, 'r') as text_file:
        text_lines = text_file.readlines()

    out_text = ''
    str_index = -1

    for line in text_lines:
        if line.startswith('#') or str_index < 0:
            out_text += line

        if line.startswith('#text'):
            str_index += 1

    with open(text_path, 'w') as text_file:
        text_file.write(out_text)


if __name__ == '__main__':
    for text_path in glob.glob(f'assets/text/*.txt'):
        clean_text(text_path)
