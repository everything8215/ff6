#!/usr/bin/env python3

import binascii
import os
import sys
import romtools as rt

cutscene_path_list = {
    0x89AF65BC: 'assets/cutscene_jp.lz',
    0x8F821696: 'assets/cutscene_en.lz',
}


def encode_lzss(src):
    # create a source buffer preceded by 2K of empty space
    # (this increases compression for some data)
    src[0:0] = bytearray(0x0800)
    s = 0x0800  # start at 0x0800 to ignore the 2K of empty space

    # destination buffer
    dest = bytearray(0x10000)
    d = 2  # start at 2 so we can fill in the length at the end

    # lzss header byte and mask
    header = 0
    mask = 1

    # lzss line buffer
    line = bytearray(17)
    l = 1  # start at 1 so we can fill in the header at the end
    b = 0x07DE  # buffer position

    while s < len(src):
        # find the longest sequence that matches the decompression buffer
        max_run = 0
        max_offset = 0
        for offset in range(1, 0x0801):
            run = 0

            while src[s + run - offset] == src[s + run]:
                run += 1
                if run == 34 or (s + run) == len(src):
                    break

            if run > max_run:
                # this is the longest sequence so far
                max_run = run
                max_offset = (b - offset) & 0x07FF

        # check if the longest sequence is compressible
        if max_run >= 3:
            # sequence is compressible
            # add compressed data to line buffer
            w = ((max_run - 3) << 11) | max_offset
            line[l] = w & 0xFF
            l += 1
            line[l] = w >> 8
            l += 1
            s += max_run
            b += max_run
        else:
            # sequence is not compressible
            # update header byte and add byte to line buffer
            header |= mask
            line[l] = src[s]
            l += 1
            s += 1
            b += 1

        b &= 0x07FF
        mask <<= 1

        if mask == 0x0100:
            # finished a line, copy it to the destination
            line[0] = header
            dest[d:d + l] = line[0:l]

            d += l
            header = 0
            l = 1
            mask = 1

    if mask != 1:
        # we're done with all the data but we're still in the middle of a line
        line[0] = header
        dest[d:d + l] = line[0:l]
        d += l

    # fill in the length
    dest[0] = d & 0xFF
    dest[1] = (d >> 8) & 0xFF

    return dest[:d]


if __name__ == '__main__':
    src_path = sys.argv[1]
    dest_path = sys.argv[2]

    # open source file
    with open(src_path, 'rb') as src_file:
        src_data = bytearray(src_file.read())

    # calculate CRC32
    crc32 = binascii.crc32(src_data) & 0xFFFFFFFF
    print('Cutscene CRC32: ', rt.hex_string(crc32))

    # check if it matches a vanilla cutscene program
    if crc32 in cutscene_path_list:
        print('Copying vanilla cutscene program')
        vanilla_cutscene_path = cutscene_path_list[crc32]
        cutscene_file = open(vanilla_cutscene_path, 'rb')
        cutscene_data = bytearray(cutscene_file.read())
    else:
        print('Encoding modified cutscene program')
        cutscene_data = encode_lzss(src_data)

    # write the encoded cutscene data to the destination file
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    with open(dest_path, 'wb') as dest_file:
        dest_file.write(cutscene_data)
