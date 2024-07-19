import re
import romtools as rt


ESCAPE_REGEX = r'{(\w+)(?:\:(\w+))?}'


class TextCodec:

    def __init__(self, char_table):

        # merge multiple character tables into a single list
        if isinstance(char_table, list):
            merged_char_table = {}
            for partial_char_table in char_table:
                assert isinstance(partial_char_table, dict)
                merged_char_table.update(partial_char_table)
            char_table = merged_char_table
        else:
            assert isinstance(char_table, dict)

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

        self.encoding_keys = self.encoding_table.keys()
        self.terminator_code = self.encoding_table.get('{0}')

    def decode_text(self, text_bytes):
        text = ''
        i = 0

        while i < len(text_bytes):
            # get the next byte
            char_code = text_bytes[i]
            i += 1

            # check for a 2-byte code
            if i < len(text_bytes) and char_code != 0:
                two_byte_code = (char_code << 8) | text_bytes[i]
                if two_byte_code in self.decoding_table:
                    char_code = two_byte_code
                    i += 1

            if char_code not in self.decoding_table:
                # value is not in decoding table
                text += '{' + rt.hex_string(char_code, 2) + '}'
                continue

            # get value from decoding table
            char_value = self.decoding_table[char_code]

            if char_value[0] != '{' or char_value[-1] != '}':
                # normal text code
                text += char_value
                continue

            if char_value == '{0}':
                # string terminator
                break

            # look for a parameter in the escape code
            escape_match = re.match(ESCAPE_REGEX, char_value)
            if escape_match is None:
                # probably missing the closing brace
                raise ValueError('Invalid escape code:', char_value)

            elif escape_match.group(2) == 'b':
                # 1-byte parameter
                param = str(text_bytes[i])
                i += 1
                char_value = re.sub(ESCAPE_REGEX, r'{\1:' + param + '}', char_value)

            elif escape_match.group(2) == 'w':
                # 2-byte parameter
                param = str(text_bytes[i] << 8 | text_bytes[i + 1])
                i += 2
                char_value = re.sub(ESCAPE_REGEX, r'{\1:' + param + '}', char_value)

            elif escape_match.group(2) is not None:
                print(escape_match.group(2))
                raise ValueError('Parameter must be either byte (b) or word (w):', char_value)

            text += char_value

        # remove padding from the end of the string
        while text.endswith('{pad}'):
            text = text[:-5]

        return text

    def encode_text(self, text_str):
        i = 0
        key_list = self.encoding_table.keys()
        text_codes = []

        while i < len(text_str):

            if text_str[i] != '{':
                # find values that match the remaining string
                match_keys = filter(lambda x: text_str[i:].startswith(x), key_list)
                match_keys = list(match_keys)
                if len(match_keys) == 0:
                    raise ValueError('Unable to encode character:', text_str[i])

                # find the longest match
                key = max(match_keys, key=len)

                # increment string pointer
                i += len(key)

                # append the text code
                text_codes.append(self.encoding_table[key])
                continue

            escape_match = re.match(ESCAPE_REGEX, text_str[i:])
            if escape_match is None:
                raise ValueError('Invalid escape sequence:', text_str)

            escape_str = escape_match.group(0)

            if escape_match.group(1).startswith('{0x'):
                # parse raw hex value
                value = escape_match.group(1)
                text_codes.append(int(value))
                i += len(escape_match)
                continue

            elif escape_str == '{0}':
                # force end of string if terminator found
                break

            elif escape_match.group(2) is not None:
                # escape code with a parameter
                escape_param = int(escape_match.group(2))

                b_code = re.sub(ESCAPE_REGEX, r'{\1:b}', escape_str)
                if b_code in key_list:
                    # escape code with no parameter
                    i += len(escape_str)
                    text_codes.append(self.encoding_table[b_code])
                    text_codes.append(escape_param)
                    continue

                w_code = re.sub(ESCAPE_REGEX, r'{\1:w}', escape_str)
                if w_code in key_list:
                    # escape code with no parameter
                    i += len(escape_str)
                    text_codes.append(self.encoding_table[w_code])
                    text_codes.append(escape_param & 0xFF)
                    text_codes.append(escape_param >> 8)
                    continue

            elif escape_str in key_list:
                # escape code with no parameter
                i += len(escape_match.group(0))
                text_codes.append(self.encoding_table[escape_str])
                continue

        text_bytes = bytearray()
        for code in text_codes:

            if code > 0xFF:
                # 2-byte code
                text_bytes.append(code >> 8)
                text_bytes.append(code & 0xFF)
            else:
                # 1-byte code
                text_bytes.append(code)

        if self.terminator_code is not None:
            text_bytes.append(self.terminator_code)

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

            if value == '{0}':
                # found string terminator
                break

            elif value[0] == '{' and value[-1] == '}':
                # check for an escape code parameter
                escape_match = re.match(ESCAPE_REGEX, value)
                if escape_match is not None:
                    i += int(escape_match.group(1))

        return min(i, len(text_bytes))
