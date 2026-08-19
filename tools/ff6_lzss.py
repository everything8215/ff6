#!/usr/bin/env python3

import sys


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
        best_run = 0
        best_offset = 0

        for run in range(34, 2, -1):
            if s + run > len(src):
                continue
            offset = src[s - 0x0800:s + run - 1].rfind(src[s:s + run])
            if offset != -1:
                best_run = run
                best_offset = (b + offset) & 0x07FF
                break

        # check if the longest sequence is compressible
        if best_run != 0:
            # sequence is compressible
            # add compressed data to line buffer
            w = ((best_run - 3) << 11) | best_offset
            line[l] = w & 0xFF
            line[l + 1] = w >> 8
            l += 2
            s += best_run
            b += best_run
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


def decode_lzss(src):

    # return an empty buffer if the source buffer is empty
    if len(src) < 2:
        return bytearray(0)

    s = 0  # source pointer

    # destination buffer
    dest = bytearray(0x10000)
    d = 0

    # lzss buffer
    buffer = bytearray(0x0800)
    b = 0x0800 - 34  # buffer pointer

    # current line
    line = bytearray(34)

    # read the compressed data length
    length = src[s] | (src[s + 1] << 8)
    s += 2

    while s < length:

        # read header byte
        header = src[s]
        s += 1

        for _ in range(8):
            l = 0
            if (header & 1) == 1:
                # single byte (uncompressed)
                c = src[s]
                s += 1
                line[l] = c
                buffer[b] = c
                l += 1
                b = (b + 1) & 0x07FF
            else:
                # 2-bytes (compressed)
                w = src[s] | (src[s + 1] << 8)
                s += 2
                r = (w >> 11) + 3

                for i in range(r):
                    c = buffer[(w + i) & 0x07FF]
                    line[l] = c
                    buffer[b] = c
                    l += 1
                    b = (b + 1) & 0x07FF

            if (d + l) > len(dest):
                # maximum destination buffer length exceeded
                dest[d:] = line[:len(dest) - d]
                return dest
            else:
                # copy this pass to the destination buffer
                dest[d:d + l] = line[:l]
                d += l

            # reached end of compressed data
            if (s >= length):
                break

            header >>= 1

    return dest[:d]


if __name__ == '__main__':

    # Ensure we have at least one input file and one output file
    if len(sys.argv) < 3:
        print("Usage: python ff6_lz.py <input_file1> [input_file2 ...] <output_file>", file=sys.stderr)
        sys.exit(1)

    # The last argument is always the destination
    dest_path = sys.argv[-1]

    # All arguments in between the script name and the destination are inputs
    src_paths = sys.argv[1:-1]

    # Initialize an empty bytearray to pool the inputs
    combined_bytes = bytearray()

    # Loop through and concatenate all input files
    for path in src_paths:
        with open(path, 'rb') as f:
            combined_bytes.extend(f.read())

    # Compress the unified data and write it to the output file
    with open(dest_path, 'wb') as f:
        f.write(encode_lzss(combined_bytes))