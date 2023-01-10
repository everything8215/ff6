def hex_string(num, pad=None, prefix='0x'):
    if pad is not None:
        pad = int(pad)
    elif num < 0x0100:
        pad = 2
    elif num < 0x010000:
        pad = 4
    elif num < 0x01000000:
        pad = 6
    else:
        pad = 8

    return '%s%0*X' % (prefix, pad, num)
