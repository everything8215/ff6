import math
import re
import romtools as rt


class DataCodec:

    format_list = {}

    def __init__(self, format):

        # generate the encoding and decoding steps
        self.encode_list = []
        if isinstance(format, list):
            # multi-format
            for format_step in format:
                self.encode_list.append(self.parse_format(format_step))
        elif isinstance(format, str):
            # single format
            self.encode_list.append(self.parse_format(format))

        # the decode list is the encode list in the opposite order
        self.decode_list = reversed(self.encode_list)

    def parse_format(self, format_str):

        format = {'raw': format_str}

        # parse the format name
        name_match = re.match(r'[^\(]+', format_str)
        assert name_match is not None
        format_name = name_match.group(0)
        format['name'] = format_name

        # get the encoding and decoding functions
        try:
            codec = DataCodec.format_list[format_name]
        except KeyError:
            raise KeyError(f'Unknown data format: {format_name}')

        format['encode'] = codec['encode']
        format['decode'] = codec['decode']

        # parse arguments
        args_match = re.match(r'.*\((.*?)\)', format_str)
        if args_match is None:
            # no arguments
            return format

        args_int_list = []
        args_str_list = args_match.group(1).split(',')
        for arg_str in args_str_list:
            arg_int = int(arg_str, 0)
            args_int_list.append(arg_int)
        format['args'] = args_int_list

        return format

    def encode(self, data):

        for format in self.encode_list:
            assert 'encode' in format
            encode_fn = format['encode']
            if 'args' in format:
                data = encode_fn(data, format['args'])
            else:
                data = encode_fn(data)

        return data

    def decode(self, data):

        for format in self.decode_list:
            assert 'decode' in format
            decode_fn = format['decode']
            if 'args' in format:
                data = decode_fn(data, format['args'])
            else:
                data = decode_fn(data)

        return data

    def init_default_formats():
        DataCodec.add_format('byteSwapped', byte_swap, byte_swap)
        DataCodec.add_format('interlace', interlace, interlace)
        DataCodec.add_format('ff6-animation-frame', default_encode,
                             default_decode)
        DataCodec.add_format('ff6-animation-tilemap', default_encode,
                             default_decode)
        DataCodec.add_format('snes4bpp', default_encode, default_decode)
        DataCodec.add_format('snes3bpp', default_encode, default_decode)
        DataCodec.add_format('snes2bpp', default_encode, default_decode)
        DataCodec.add_format('linear1bpp', default_encode, default_decode)
        DataCodec.add_format('linear2bpp', default_encode, default_decode)
        DataCodec.add_format('linear4bpp', default_encode, default_decode)
        DataCodec.add_format('bgr555', default_encode, default_decode)
        DataCodec.add_format('defaultTile', default_encode, default_decode)
        DataCodec.add_format('generic4bppTile', default_encode, default_decode)
        DataCodec.add_format('snes2bppTile', default_encode, default_decode)
        DataCodec.add_format('snes3bppTile', default_encode, default_decode)
        DataCodec.add_format('snes4bppTile', default_encode, default_decode)

    def add_format(key, encode_fn, decode_fn):
        DataCodec.format_list[key] = {
            'encode': encode_fn,
            'decode': decode_fn,
        }


def interlace(data, args):
    word = args[0]
    layers = args[1]
    stride = args[2]
    step = word * layers
    block = step * stride
    length = math.ceil(len(data) / block) * block
    if len(data) != length:
        src = bytearray(length)
        src[:len(data)] = data
    else:
        src = data
    s = 0
    dest = bytearray(length)
    d = 0
    while s < length:
        s1 = s
        while (s1 - s) < step:
            s2 = s1
            while (s2 - s) < block:
                dest[d:d + word] = src[s2:s2 + word]
                d += word
                s2 += step
            s1 += word
        s += block
    return dest


def byte_swap(data, args=None):
    if (args == None):
        return bytearray(reversed(data))

    step = args[0]
    s = 0
    dest = bytearray(len(data))
    for s in range(0, len(data), step):
        dest[s:s + step] = reversed(data[s:s + step])
        s += step
    return dest


def default_encode(data, args=None):
    return data


def default_decode(data, args=None):
    return data
