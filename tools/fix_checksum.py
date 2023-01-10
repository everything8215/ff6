#!/usr/bin/env python3

import sys
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

    # write a dummy checksum in the SNES header
    rom_file.seek(checksum_offset)
    rom_file.write((0xAAAA).to_bytes(2, 'little'))
    rom_file.write((0x5555).to_bytes(2, 'little'))

    # read the ROM data and calculate the SNES checksum
    rom_file.seek(0)
    rom_data = bytearray(rom_file.read())
    checksum = mirror_sum(rom_data)
    print('SNES Checksum: ', rt.hex_string(checksum, 4))

    # write the checksum in the SNES header
    rom_file.seek(checksum_offset)
    rom_file.write((checksum ^ 0xFFFF).to_bytes(2, 'little'))
    rom_file.write(checksum.to_bytes(2, 'little'))

    rom_file.close()
