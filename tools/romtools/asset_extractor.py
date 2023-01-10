import romtools as rt
import os


class AssetExtractor:

    def __init__(self, map_mode='none'):
        self.memory_map = rt.MemoryMap(map_mode)

    def extract_asset(self, rom_data, asset_definition):
        # calculate the appropriate ROM range using the mapper
        unmapped_range = rt.Range(asset_definition['range'])
        mapped_range = self.memory_map.map_range(unmapped_range)
        asm_symbol = asset_definition['asmSymbol']
        asset_key = asset_definition['key']
        lang_suffix = asset_definition.get('lang', '')
        if lang_suffix != '':
            long_key = f'{asset_key}_{lang_suffix}'
        else:
            long_key = asset_key
        asm_path = 'src/assets/' + long_key + '.asm'
        inc_path = 'include/assets/' + long_key + '.inc'
        print(f'{unmapped_range} {asm_symbol} -> {asm_path}')

        # extract the asset data
        asset_data = rom_data[mapped_range.begin:mapped_range.end + 1]
        array_length = asset_definition.get('arrayLength', 0)
        if isinstance(array_length, str):
            array_length = int(array_length, 0)

        # make a list of pointers
        pointer_list = []

        if asset_definition['type'] != 'array':
            # single object
            pointer_list.append(0)

        elif 'pointerTable' in asset_definition:
            # array with a pointer table
            ptr_definition = asset_definition['pointerTable']
            is_mapped = ptr_definition.get('isMapped', False)
            ptr_offset = ptr_definition.get('offset', 0)
            if isinstance(ptr_offset, str):
                ptr_offset = int(ptr_offset, 0)

            if not is_mapped:
                # map the pointer offset first, then add pointers
                ptr_offset = self.memory_map.map_address(ptr_offset)

            # extract the pointer table data
            ptr_range = rt.Range(ptr_definition['range'])
            ptr_range = self.memory_map.map_range(ptr_range)
            ptr_data = rom_data[ptr_range.begin:ptr_range.end + 1]
            ptr_size = ptr_definition.get('pointerSize', 2)
            assert len(ptr_data) % ptr_size == 0, 'Pointer table length' \
                + ' is not divisible by pointer size'
            array_length = len(ptr_data) // ptr_size

            for i in range(array_length):
                pointer = 0
                pointer |= ptr_data[i * ptr_size + 0]
                if ptr_size > 1:
                    pointer |= ptr_data[i * ptr_size + 1] << 8
                if ptr_size > 2:
                    pointer |= ptr_data[i * ptr_size + 2] << 16
                if ptr_size > 3:
                    pointer |= ptr_data[i * ptr_size + 3] << 24

                pointer += ptr_offset
                if is_mapped:
                    # map pointer after adding pointer offset
                    pointer = self.memory_map.map_address(pointer)
                pointer_list.append(pointer - mapped_range.begin)

        elif 'itemOffsets' in asset_definition:
            # items with specified offsets
            item_offsets = asset_definition['itemOffsets']
            array_length = len(item_offsets)
            for begin in item_offsets:
                if isinstance(begin, str):
                    begin = int(begin, 0)
                begin = self.memory_map.map_address(begin)
                pointer_list.append(begin - mapped_range.begin)

        elif 'terminator' in asset_definition:
            # terminated items
            terminator = asset_definition['terminator']
            if isinstance(terminator, str):
                terminator = int(terminator, 0)
            pointer_list.append(0)
            for p in range(len(asset_data) - 1):
                if asset_data[p] == terminator:
                    pointer_list.append(p + 1)
            array_length = len(pointer_list)

        elif 'itemLength' in asset_definition:
            # fixed length items
            item_length = asset_definition['itemLength']
            if isinstance(item_length, str):
                item_length = int(item_length, 0)
            assert item_length * array_length == len(asset_data), \
                'Fixed-length array size mismatch'
            for i in range(array_length):
                pointer_list.append(i * item_length)

        # remove duplicates and sort pointers
        sorted_pointers = sorted(set(pointer_list))

        # create a list of pointer ranges (these may not correspond
        # with item ranges in some cases)
        pointer_ranges = {}
        for p, pointer in enumerate(sorted_pointers):
            begin = pointer
            if p == len(sorted_pointers) - 1:
                end = len(asset_data) - 1
            else:
                end = sorted_pointers[p + 1] - 1
            pointer_ranges[begin] = rt.Range(begin, end)

        # create ranges for each item
        item_ranges = []
        label_offsets = {}

        for i in range(array_length):
            begin = pointer_list[i]
            if 'terminator' in asset_definition:
                # item range goes until terminator is found
                end = begin
                terminator = asset_definition['terminator']
                if isinstance(terminator, str):
                    terminator = int(terminator, 0)
                while end < len(asset_data):
                    if asset_data[end] == terminator:
                        break
                    end = end + 1
                item_ranges.append(rt.Range(begin, end))

            elif asset_definition.get('isSequential', False):
                if i != array_length - 1:
                    # item range goes up to next sequential pointer
                    end = pointer_list[i + 1] - 1
                else:
                    # last item goes up to end of asset range
                    end = len(asset_data) - 1
                item_ranges.append(rt.Range(begin, end))

            else:
                # otherwise, item range is same as pointer range
                item_ranges.append(pointer_ranges[begin])

            # generate a label
            if asset_definition['type'] == 'array':
                if begin in label_offsets:
                    label_offsets[begin].append(i)
                else:
                    label_offsets[begin] = [i]

        # create byte-matching asm files if they don't exist
        if not os.path.exists(inc_path):
            inc_string = '; this file is generated automatically,' \
                + ' do not modify manually\n\n'
            inc_string += '.list off\n'

            # include guard
            inc_string += f'.ifndef {asset_key.upper()}_INC\n'
            inc_string += f'{asset_key.upper()}_INC = 1\n\n'

            # import/export asset symbol
            inc_string += f'.global {asm_symbol}\n'

            # import/export asset pointer table
            if 'pointerTable' in asset_definition:
                inc_string += f'.global {asm_symbol}Ptrs\n'
            inc_string += '\n'

            # define asset size
            inc_string += f'.define {asset_key.upper()}_SIZE '
            size_str = rt.hex_string(mapped_range.length(), 4, "$").lower()
            inc_string += f'{size_str}\n'

            # define asset array length and item size
            if asset_definition['type'] == 'array':
                inc_string += f'.define {asset_key.upper()}_ARRAY_LENGTH '
                inc_string += f'{len(item_ranges)}\n'
                if 'itemLength' in asset_definition:
                    item_length = asset_definition['itemLength']
                    if isinstance(item_length, str):
                        item_length = int(item_length, 0)
                    inc_string += f'.define {asset_key.upper()}_ITEM_SIZE '
                    inc_string += f'{item_length}\n'
            inc_string += '\n.endif\n'
            inc_string += '.list on\n'

            # save asset include file
            os.makedirs(os.path.dirname(inc_path), exist_ok=True)
            with open(inc_path, 'w') as f:
                f.write(inc_string)

        if not os.path.exists(asm_path):
            asm_string = '; this file is generated automatically,' \
                + ' do not modify manually\n\n'
            asm_string += '.list off\n'
            asm_string += '\n'

            # asset label
            asm_string += f'\n{asm_symbol}:\n'

            for pointer in sorted_pointers:
                # skip if pointer is out of range
                if pointer < 0 or pointer > len(asset_data):
                    continue

                # print item labels
                if pointer in label_offsets:
                    for i in label_offsets[pointer]:
                        i_string = rt.hex_string(i, 4, '').lower()
                        asm_string += f'\n{asm_symbol}_{i_string}:'

                # print the data
                slice_begin = pointer_ranges[pointer].begin
                slice_end = pointer_ranges[pointer].end
                pointer_data = asset_data[slice_begin:slice_end + 1]
                for b, value in enumerate(pointer_data):
                    if (b % 16 == 0):
                        asm_string += '\n        .byte   '
                    else:
                        asm_string += ','
                    asm_string += rt.hex_string(value, 2, '$').lower()
                asm_string += '\n'
            asm_string += '\n.list on\n'

            # save asset assembly file
            os.makedirs(os.path.dirname(asm_path), exist_ok=True)
            with open(asm_path, 'w') as f:
                f.write(asm_string)
