#!/usr/bin/env python3

import numpy as np
import wave
import sys

# BRR delta filter coefficients
BRR_DELTA_COEFF = [[0, 0, 1, 0, 0], [1, -1, 16, 0, 0], [2, -3, 32, -1, 1],
                   [2, -13, 64, -1, 3]]


def calc_delta(filter, p1, p2):
    '''
    Calculate a BRR delta value from the previous two pcm values

    Args:
        filter (int): filter index (0..3)
        p1 (int): previous pcm value (15-bit)
        p2 (int): next previous pcm value (15-bit)

    Returns:
        (int): delta value added to the current pcm value
    '''

    try:
        coeff = BRR_DELTA_COEFF[filter]
    except IndexError:
        raise ValueError('Invalid BRR filter: %d' % filter)

    p0 = coeff[0] * p1
    p0 += (coeff[1] * p1) // coeff[2]
    p0 += coeff[3] * p2
    p0 += (coeff[4] * p2) // 16
    return p0


def decode_nybble(nybble, header, prev):
    '''
    Decode a single nybble of a BRR sample into pcm

    Args:
        nybble (int): nybble value (0..15)
        header (int): header byte of BRR block (8-bit)
        prev (array): previous two pcm values (15-bit)

    Returns:
        (int): decoded pcm value (15-bit)
    '''

    if nybble < 0 or nybble > 15:
        raise ValueError('Invalid BRR nybble value: %d' % nybble)

    # fix sign of nybble
    val = nybble if nybble < 8 else nybble - 16

    # extract the shift and filter from the header byte
    shift = (header & 0xF0) >> 4
    filter = (header & 0x0C) >> 2

    # shift > 12 has weird behavior
    if shift > 12:
        shift = 12
        val >>= 3

    # apply the shift
    val <<= shift
    val >>= 1

    # apply delta filter
    val += calc_delta(filter, prev[1], prev[0])

    # clamp to 16 bits
    val = max(-0x8000, min(val, 0x7FFF))

    # deal with 15-bit wrap-around (can result in sign error)
    if val > 0x3FFF:
        val -= 0x8000
    elif val < -0x4000:
        val += 0x8000

    return val


def decode_block(brr_block, header, prev):
    '''
    Decode an 8-byte block of BRR encoded data (16-values)

    Args:
        brr_block (array): 8-byte block of encoded samples
        header (int): header byte of BRR block (8-bit)
        prev (array): previous two pcm values (15-bit)

    Returns:
        (array): decoded pcm values (15-bit)
    '''

    # put the two previous values at the beginning of the array
    pcm_block = np.empty(18, dtype=np.int16)
    pcm_block[:2] = prev

    for i in range(16):

        # get the next nybble
        n = brr_block[i // 2]
        if i % 2 == 0:
            n >>= 4
        n &= 0x0F

        pcm_block[i + 2] = decode_nybble(n, header, pcm_block[i:i + 2])

    # trim the two previous values and return
    return pcm_block[2:]


def decode_brr(brr_data):
    '''
    Decode a BRR-encoded sample

    Args:
        brr_data (array): sample encoded as a sequence of 9-byte BRR blocks

    Returns:
        (array): decoded pcm sample (16-bit)
    '''

    # make sure the brr data is divisble by 9
    if len(brr_data) % 9 != 0:
        raise ValueError('BRR length not divisible by 9')
    n_blocks = len(brr_data) // 9

    pcm_data = np.empty(n_blocks * 16, dtype=np.int16)
    prev = np.zeros(2, dtype=np.int16)  # previous two pcm values

    for b in range(n_blocks):
        brr_offset = b * 9
        header = brr_data[brr_offset]

        # check the terminator flag
        if header & 1 and b != n_blocks - 1:
            raise ValueError('BRR terminator found before end of data')
        elif not header & 1 and b == n_blocks - 1:
            raise ValueError('No BRR terminator found at end of data')

        brr_block = brr_data[brr_offset + 1:brr_offset + 9]

        pcm_block = decode_block(brr_block, header, prev)
        pcm_offset = b * 16
        pcm_data[pcm_offset:pcm_offset + 16] = pcm_block

        # update the previous two values
        prev = pcm_block[-2:]

    # shift to convert to 16-bit
    return pcm_data << 1


def encode_block(pcm_block, header, prev):
    '''
    Encode 16 pcm values into an 8-byte BRR block

    Args:
        pcm_block (array): 16 pcm values (15-bit)
        header (int): header byte of BRR block (8-bit)
        prev (array): previous two pcm values (15-bit)

    Returns:
        (array): BRR-encoded block (8 bytes)
    '''
    brr_block = np.zeros(8, dtype=np.uint8)
    for i in range(16):
        best_n = 0
        best_p = 0
        best_diff = -1

        # find the optimal value for this nybble
        for n in range(16):
            p = decode_nybble(n, header, prev)

            diff = abs(p - pcm_block[i])
            if best_diff == -1 or diff < best_diff:
                best_diff = diff
                best_n = n
                best_p = p

        # save the previous pcm value for the optimal brr nybble
        prev[0] = prev[1]
        prev[1] = best_p

        if i % 2:
            # odd nybbles
            brr_block[i // 2] |= best_n
        else:
            # even nybbles
            brr_block[i // 2] |= best_n << 4

    return brr_block


def encode_brr(pcm_data, loop=True):
    '''
    Encode a BRR sample

    Args:
        pcm_data (array): sample encoded as 16-bit, 32 kHz pcm data
        loop (bool): set loop flag at end of sample

    Returns:
        (array): encoded brr sample
    '''

    # add an empty block if any of the first 16 pcm values aren't zero
    if np.any(pcm_data[0:16]):
        empty_block = np.zeros(16, dtype=np.int16)
        pcm_data = np.concatenate([empty_block, pcm_data])

    # determine the number of blocks required
    n_blocks = len(pcm_data) // 16
    if len(pcm_data) % 16 != 0:
        n_blocks += 1

    # add padding at the end if the number of values is not divisible by 16
    pcm_len_mod16 = len(pcm_data) % 16
    if pcm_len_mod16 != 0:
        padding = np.zeros(16 - pcm_len_mod16, dtype=np.int16)
        pcm_data = np.concatenate(pcm_data, padding)

    brr_data = np.empty(n_blocks * 9, dtype=np.uint8)
    prev = np.zeros(2, dtype=np.int16)

    # convert pcm data to 15-bit by shifting out the LSB
    pcm_data >>= 1

    for b in range(n_blocks):
        pcm_offset = b * 16
        pcm_block = pcm_data[pcm_offset:pcm_offset + 16]

        best_header = 0
        best_error = -1
        best_brr = np.zeros(8, dtype=np.uint8)
        best_pcm = np.zeros(16, dtype=np.int16)

        if b == n_blocks - 1:
            # last block
            header_flags = 3 if loop else 1
        else:
            # this matches most samples but could also be zero
            header_flags = 2

        for shift in range(13):
            # use shift 0 for the first block
            if b == 0 and shift > 0:
                break

            for filter in range(4):

                # must use filter 0 for the first block
                if b == 0 and filter > 0:
                    break

                # set the header
                header = shift << 4 | filter << 2 | header_flags

                brr_block = encode_block(pcm_block, header, np.copy(prev))
                actual_pcm = decode_block(brr_block, header, np.copy(prev))
                error = np.sum(np.abs(pcm_block - actual_pcm))

                if error <= best_error or best_error == -1:
                    best_header = header
                    best_error = error
                    best_brr = brr_block
                    best_pcm = actual_pcm

                # print('%04d %02x %d' % (b, header, error))

        print('%04d %02x %d' % (b, best_header, best_error), best_brr)
        prev = best_pcm[14:]

        brr_offset = b * 9
        brr_data[brr_offset] = best_header
        brr_data[brr_offset + 1:brr_offset + 9] = best_brr

    return brr_data


if __name__ == '__main__':

    brr_path = sys.argv[1]
    wav_path = sys.argv[2]

    with open(brr_path, 'rb') as brr_file:
        brr_data = np.fromfile(brr_file, dtype=np.uint8)

    # read the length (2-byte header)
    brr_length = brr_data[0] | (brr_data[1] << 8)
    if brr_length == len(brr_data) - 2:
        brr_data = brr_data[2:]
        # raise ValueError('BRR file length mismatch')

    pcm_data = decode_brr(brr_data)

    # create a wave file
    with wave.open(wav_path, 'wb') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(32000)
        wav_file.setnframes(len(pcm_data))

        # write the pcm values to the wave file
        wav_file.writeframes(bytes(pcm_data))

    # test_brr = encode_brr(pcm_data)
    # with open('test.brr', 'wb') as test_file:
    #     test_file.write(test_brr)
