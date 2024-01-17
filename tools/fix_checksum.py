#!/usr/bin/env python3

import binascii
import sys
import numpy as np
import romtools as rt


# from snes9x and NSRT
def mirror_sum(data, mask=0x800000):
    while (len(data) & mask) == 0 and mask != 0:
        mask = mask >> 1

    part1 = sum(data[0:mask]) & 0xFFFF
    part2 = 0

    next_length = len(data) - mask
    if next_length != 0:
        part2 = mirror_sum(data[mask:], mask >> 1)

        while next_length < mask:
            next_length = next_length * 2
            part2 = part2 * 2

    return (part1 + part2) & 0xFFFF


if __name__ == "__main__":
    # open the ROM file
    rom_path = sys.argv[1]
    rom_file = open(rom_path, 'r+b')

    checksum_offset = 0xFFDC  # 0x7FDC for LoROM
    checksum = np.array([0xAAAA, 0x5555], dtype=np.uint16)

    # write a dummy checksum in the SNES header
    rom_file.seek(checksum_offset)
    rom_file.write(checksum.tobytes())

    # read the ROM data and calculate the SNES checksum
    rom_file.seek(0)
    rom_bytes = bytearray(rom_file.read())
    checksum[1] = mirror_sum(rom_bytes)
    checksum[0] = checksum[1] ^ 0xFFFF
    rom_bytes[checksum_offset:checksum_offset+4] = checksum.tobytes()

    # print the result
    print('SNES Checksum:', rt.hex_string(checksum[1], 4))
    print('ROM CRC32:', rt.hex_string(binascii.crc32(rom_bytes) & 0xFFFFFFFF, 8))

    # write the calculated checksum in the SNES header
    rom_file.seek(checksum_offset)
    rom_file.write(checksum.tobytes())
    rom_file.close()
