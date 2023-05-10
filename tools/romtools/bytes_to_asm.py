import romtools as rt


def bytes_to_asm(bytes, labels=None, symbols=None):
    asm_string = ''
    unique_offsets = set([0])  # always include the start of the data

    if labels is None:
        labels = []

    # generate a list of labels for each offset
    label_offsets = {}
    for i, (begin, label_str) in enumerate(labels):
        # generate a label
        unique_offsets.add(begin)
        if begin in label_offsets:
            label_offsets[begin].add(label_str)
        else:
            label_offsets[begin] = set([label_str])

    if symbols is None:
        symbols = []

    # find symbols for each offset
    symbol_offsets = {}
    for (begin, type, symbol_str) in symbols:
        # can only have 1 symbol per offset
        symbol_offsets[begin] = (type, symbol_str)
        unique_offsets.add(begin)

    # remove duplicates and sort pointers
    sorted_offsets = list(sorted(unique_offsets))

    for offset_index, offset in enumerate(sorted_offsets):
        # skip if pointer is out of range
        if offset < 0 or offset > len(bytes):
            continue

        slice_begin = offset

        # print labels
        if offset in label_offsets:
            asm_string += '\n'
            for label_str in label_offsets[offset]:
                asm_string += f'\n{label_str}:'

        # print symbol tokens
        if offset in symbol_offsets:
            (type, symbol_str) = symbol_offsets[offset]

            # determine the value size
            if type == '.byte':
                width = 1
            if type == '.word' or type == '.addr':
                width = 2
            elif type == '.faraddr':
                width = 3
            elif type == '.dword':
                width = 4
            else:
                raise ValueError(f'Invalid symbol value type: {type}')

            # increment the beginning of the slice
            slice_begin += width

            if '#' in symbol_str:

                # get the current value
                value = bytes[slice_begin]
                if width > 1:
                    value |= bytes[slice_begin + 1] << 8
                if width > 2:
                    value |= bytes[slice_begin + 2] << 16
                if width > 3:
                    value |= bytes[slice_begin + 3] << 24
                value_str = rt.hex_string(value, width * 2, '$').lower()

                # replace '#' with value
                symbol_str = symbol_str.replace('#', value_str)

            asm_string += '\n' + type.ljust(8).rjust(16) + symbol_str

        next_offset = len(bytes)
        if offset_index != len(sorted_offsets) - 1:
            next_offset = sorted_offsets[offset_index + 1]

        if slice_begin >= next_offset:
            # no bytes to print
            continue

        # print the bytes
        slice_bytes = bytes[slice_begin:next_offset]
        for b, value in enumerate(slice_bytes):
            if (b % 16 == 0):
                asm_string += '\n' + '.byte'.ljust(8).rjust(16)
            else:
                asm_string += ','
            asm_string += rt.hex_string(value, 2, '$').lower()

    return asm_string
