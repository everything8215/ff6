#!/usr/bin/env python3

import binascii
import sys
import numpy as np
import romtools as rt


if __name__ == "__main__":
    # open the ROM file
    rom_path = sys.argv[1]
    with open(rom_path, 'rb') as rom_file:
        rom_bytes = bytearray(rom_file.read())

    checksum_offset = 0xFFDC  # 0x7FDC for LoROM
    checksum = np.array([0xAAAA, 0x5555], dtype=np.uint16)

    # write a dummy checksum in the SNES header
    rom_bytes[checksum_offset:checksum_offset+4] = checksum.tobytes()

    # read the ROM data and calculate the SNES checksum
    checksum[1] = rt.mirror_sum(rom_bytes)
    checksum[0] = checksum[1] ^ 0xFFFF
    rom_bytes[checksum_offset:checksum_offset+4] = checksum.tobytes()

    # print the result
    print('SNES Checksum: 0x%04X' % checksum[1])
    print('ROM CRC32: 0x%08X' % (binascii.crc32(rom_bytes) & 0xFFFFFFFF))

    # write the calculated checksum in the SNES header
    with open(rom_path, 'wb') as rom_file:
        rom_file.write(rom_bytes)
