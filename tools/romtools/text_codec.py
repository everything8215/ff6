import re
import romtools as rt


class TextCodec:

    def __init__(self, char_table):

        # merge multiple character tables into a single list
        if isinstance(char_table, list):
            merged_char_table = {}
            for partial_char_table in char_table:
                assert isinstance(partial_char_table, dict)
                merged_char_table.update(partial_char_table)
            char_table = merged_char_table

        self.decoding_table = {}
        self.encoding_table = {}

        for code in char_table:

            value = char_table[code]
            if isinstance(code, str):
                try:
                    code = int(code, 0)
                except ValueError:
                    raise ValueError('Invalid character table code:', code)

            assert isinstance(code, int)

            if isinstance(value, list):
                # multiple representations of the same code
                primary_value = value[0]
                for multi_value in value:
                    assert isinstance(multi_value, str)
                    self.encoding_table[multi_value] = code
            else:
                # single value
                primary_value = value
                self.encoding_table[value] = code

            assert isinstance(primary_value, str)

            self.decoding_table[code] = primary_value

    def decode_text(self, text_bytes):
        text = ''
        i = 0

        while i < len(text_bytes):
            # get the next byte
            char_code = text_bytes[i]
            i += 1

            # check for a 2-byte code
            if i < len(text_bytes) and char_code != 0:
                byte2 = text_bytes[i]
                two_byte_code = (char_code << 8) | byte2
                if two_byte_code in self.decoding_table:
                    char_code = two_byte_code
                    i += 1

            if char_code not in self.decoding_table:
                # value is not in decoding table
                text += rt.hex_string(char_code, 2, r'\x')
                continue

            # get value from decoding table
            char_value = self.decoding_table[char_code]

            if char_value == r'\0':
                # string terminator
                break

            elif char_value.endswith('[['):
                # 2-byte parameter
                if i + 1 >= len(text_bytes):
                    raise ValueError('Text code missing parameter value:',
                                     char_value)
                text += char_value
                param = (text_bytes[i] << 8) | text_bytes[i + 1]
                text += rt.hex_string(param, 4)
                text += ']]'
                i += 2

            elif char_value.endswith('['):
                # 1-byte parameter
                if i >= len(text_bytes):
                    raise ValueError('Text code missing parameter value:',
                                     char_value)
                text += char_value
                text += rt.hex_string(text_bytes[i], 2)
                text += ']'
                i += 1

            else:
                # normal character
                text += char_value

        # remove padding from the end of the string
        while text.endswith(r'\pad'):
            text = text[:-4]

        return text

    def encode_text(self, text_str):
        i = 0
        key_list = self.encoding_table.keys()
        text_bytes = bytearray()

        while i < len(text_str):

            if text_str[i:].startswith(r'\x'):
                # parse raw hex value
                raw_str = text_str[i:i + 4]
                find_value = re.match(r'\x([0-9a-fA-F]{2})', raw_str)
                if find_value is None:
                    raise ValueError('Invalid raw text:', raw_str)
                value = find_value.group(1)
                text_bytes.append(int(value, 16))
                i += 4
                continue

            # find values that match the remaining string
            match_keys = filter(lambda x: text_str[i:].startswith(x), key_list)
            match_keys = list(match_keys)
            if len(match_keys) == 0:
                raise ValueError('Unable to encode character:', text_str[i])

            # find the longest match
            key = max(match_keys, key=len)

            # force end of string if terminator found
            if key == '\0':
                break

            code = self.encoding_table[key]
            if code > 0xFF:
                # 2-byte code
                text_bytes.append(code >> 8)
                text_bytes.append(code & 0xFF)
            else:
                # 1-byte code
                text_bytes.append(code)

            # increment string pointer
            i += len(key)

            # encode parameter
            if key.endswith('[['):
                # 2-byte parameter
                find_param = re.match(r'(.*)\]\]', text_str[i:])
                if find_param is None:
                    raise ValueError('Text code missing parameter:', key)
                param = find_param.group(1)
                try:
                    value = int(param, 0)
                except ValueError:
                    raise TypeError('Invalid text code parameter:', param)

                if value > 0xFFFF:
                    raise ValueError('Invalid text code parameter:', value)
                text_bytes.append(value >> 8)
                text_bytes.append(value & 0xFF)
                i += len(param) + 2

            elif key.endswith('['):
                # 1-byte parameter
                find_param = re.match(r'(.*)\]', text_str[i:])
                if find_param is None:
                    raise ValueError('Text code missing parameter:', key)
                param = find_param.group(1)
                try:
                    value = int(param, 0)
                except ValueError:
                    raise TypeError('Invalid text code parameter:', param)

                if value > 0xFF:
                    raise ValueError('Invalid text code parameter:', value)
                text_bytes.append(value)
                i += len(param) + 1

        if r'\0' in self.encoding_table:
            text_bytes.append(self.encoding_table[r'\0'])

        return text_bytes

    def text_length(self, text_bytes):
        i = 0

        while i < len(text_bytes):
            code = text_bytes[i] << 8
            i += 1

            # get the next byte unless we just reached the end of the data
            if i != len(text_bytes):
                code |= text_bytes[i]

            # check for a 2-byte code
            if (code & 0xFF) != 0 and code in self.decodingTable:
                i += 1
            else:
                # 1-byte code
                code >>= 8

            value = self.decodingTable.get(code & 0xFF, '')

            if value == r'\0':
                # found string terminator
                break

            elif value.endswith('[['):
                # command with 2-byte parameter
                i += 2

            elif value.endswith('['):
                # command with 1-byte parameter
                i += 1

        return min(i, len(text_bytes))
