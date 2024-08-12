'''
Convert an integer into a string in hexadecimal format. The output string can
optionally be padded with zeros and prefix can optionally be added to the
front of the string.
'''

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
