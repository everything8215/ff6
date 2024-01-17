#!/usr/bin/env python3

import numpy as np
import romtools as rt
import sys


def create_stencil(gfx_bytes, tile_size):

    trimmed_gfx = bytearray()

    if len(gfx_bytes) == 64 * tile_size:
        stencil_bytes = np.zeros(8, dtype=np.uint8)
        mask = 0x80
        stencil_offset = 0
        for i in range(64):
            gfx_begin = i * tile_size
            gfx_end = gfx_begin + tile_size
            if not all(b == 0 for b in gfx_bytes[gfx_begin:gfx_end]):
                trimmed_gfx += gfx_bytes[gfx_begin:gfx_end]
                stencil_bytes[stencil_offset] |= mask

            mask >>= 1
            if mask == 0:
                mask = 0x80
                stencil_offset += 1

    elif len(gfx_bytes) == 256 * tile_size:
        stencil_bytes = np.zeros(16, dtype='>i2')
        mask = 0x8000
        stencil_offset = 0
        for i in range(256):
            gfx_begin = i * tile_size
            gfx_end = gfx_begin + tile_size
            if not all(b == 0 for b in gfx_bytes[gfx_begin:gfx_end]):
                trimmed_gfx += gfx_bytes[gfx_begin:gfx_end]
                stencil_bytes[stencil_offset] |= mask

            mask >>= 1
            if mask == 0:
                mask = 0x8000
                stencil_offset += 1

    else:
        raise ValueError(
            'Monster graphics must be either 64x64 or 128x128 pixels')

    return trimmed_gfx, stencil_bytes.tobytes()


def apply_stencil(trimmed_gfx, stencil_bytes, tile_size):

    if len(stencil_bytes) == 8:
        num_tiles = 64
        init_mask = 0x80

    elif len(stencil_bytes) == 32:
        num_tiles = 256
        init_mask = 0x8000
        stencil_bytes = np.frombuffer(stencil_bytes, dtype='>i2')

    else:
        raise ValueError(
            'Monster graphics must be either 64x64 or 128x128 pixels')

    gfx_bytes = bytearray(num_tiles * tile_size)

    stencil_offset = 0
    trimmed_offset = 0
    mask = init_mask

    for i in range(num_tiles):
        if stencil_bytes[stencil_offset] & mask:
            gfx_begin = i * tile_size
            gfx_end = gfx_begin + tile_size
            trimmed_begin = trimmed_offset
            trimmed_end = trimmed_begin + tile_size
            gfx_bytes[gfx_begin:gfx_end] = trimmed_gfx[
                trimmed_begin:trimmed_end]
            trimmed_offset = trimmed_end

        mask >>= 1
        if mask == 0:
            mask = init_mask
            stencil_offset += 1

    return gfx_bytes


if __name__ == '__main__':

    gfx_path = sys.argv[1]
    if gfx_path.endswith('.4bpp'):
        tile_size = 32
    elif gfx_path.endswith('.3bpp'):
        tile_size = 24
    else:
        raise ValueError(f'Invalid monster graphics file: {gfx_path}')

    trimmed_path = gfx_path + '.trm'
    stencil_path = gfx_path[:-5] + '.stn'

    with open(gfx_path, 'rb') as gfx_file:
        gfx_bytes = bytearray(gfx_file.read())

    trimmed_gfx, stencil_bytes = create_stencil(gfx_bytes, tile_size)

    with open(trimmed_path, 'wb') as trimmed_gfx_file:
        trimmed_gfx_file.write(trimmed_gfx)

    with open(stencil_path, 'wb') as stencil_file:
        stencil_file.write(stencil_bytes)
