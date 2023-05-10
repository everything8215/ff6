import romtools as rt
import json
import os


class AssetManager:

    def __init__(self, asset_dir='assets', include_dir='include/assets'):
        self.asset_dir = asset_dir
        self.include_dir = include_dir

        # load text character tables
        char_tables = {}
        char_table_dir = 'tools/char_table'
        char_table_dir_list = os.listdir(char_table_dir)

        for filename in char_table_dir_list:
            split_filename = os.path.splitext(filename)
            key = split_filename[0]
            ext = split_filename[1]
            if ext != '.json':
                continue

            full_path = f'{char_table_dir}/{filename}'
            with open(full_path, 'r') as char_table_file:
                char_tables[key] = json.load(char_table_file)

        # create text codecs
        self.text_codecs = {}
        text_encoding_dir = 'tools/text_encoding'
        text_encoding_dir_list = os.listdir(text_encoding_dir)

        for filename in text_encoding_dir_list:
            split_filename = os.path.splitext(filename)
            key = split_filename[0]
            ext = split_filename[1]
            if ext != '.json':
                continue

            full_path = f'{text_encoding_dir}/{filename}'
            with open(full_path, 'r') as text_encoding_file:
                char_table_list = json.load(text_encoding_file)

            char_table = []
            for char_table_key in char_table_list:
                assert char_table_key in char_tables, f'{char_table_key}'
                char_table.append(char_tables[char_table_key])

            self.text_codecs[key] = rt.TextCodec(char_table)

    def get_asset_definition(self, key):
        definition_path = f'tools/asset_definitions/{key}.json'
        with open(definition_path, 'r') as asset_definition_file:
            return json.load(asset_definition_file)

    def extract_asset(self, key, rom_bytes, memory_map):

        asset_definition = self.get_asset_definition(key)

        # calculate the appropriate ROM range using the mapper
        unmapped_range = rt.Range(asset_definition['range'])
        mapped_range = memory_map.map_range(unmapped_range)
        asm_symbol = asset_definition['asmSymbol']
        asm_path = f'{self.include_dir}/{key}.asm'
        print(f'{unmapped_range} {asm_symbol} -> {asm_path}')

        # extract the asset data
        asset_data = rom_bytes[mapped_range.begin:mapped_range.end + 1]

        # make a list of pointers for each item in the asset
        pointer_list = []

        if asset_definition['type'] != 'array':
            # single object
            pointer_list.append(0)
            array_length = 1

        elif 'pointerTable' in asset_definition:
            # array with a pointer table
            ptr_definition = asset_definition['pointerTable']
            is_mapped = ptr_definition.get('isMapped', False)
            ptr_offset = ptr_definition.get('offset', 0)
            if isinstance(ptr_offset, str):
                ptr_offset = int(ptr_offset, 0)

            if not is_mapped:
                # map the pointer offset first, then add pointers
                ptr_offset = memory_map.map_address(ptr_offset)

            # extract the pointer table data
            ptr_range = rt.Range(ptr_definition['range'])
            ptr_range = memory_map.map_range(ptr_range)
            ptr_data = rom_bytes[ptr_range.begin:ptr_range.end + 1]
            ptr_size = ptr_definition.get('pointerSize', 2)
            assert len(ptr_data) % ptr_size == 0, 'Pointer table length' \
                + ' is not divisible by pointer size'
            array_length = len(ptr_data) // ptr_size

            for i in range(array_length):
                pointer = ptr_data[i * ptr_size]
                if ptr_size > 1:
                    pointer |= ptr_data[i * ptr_size + 1] << 8
                if ptr_size > 2:
                    pointer |= ptr_data[i * ptr_size + 2] << 16
                if ptr_size > 3:
                    pointer |= ptr_data[i * ptr_size + 3] << 24

                pointer += ptr_offset
                if is_mapped:
                    # map pointer after adding pointer offset
                    pointer = memory_map.map_address(pointer)
                pointer_list.append(pointer - mapped_range.begin)

        elif 'itemOffsets' in asset_definition:
            # items with specified offsets
            item_offsets = asset_definition['itemOffsets']
            array_length = len(item_offsets)
            for begin in item_offsets:
                if isinstance(begin, str):
                    begin = int(begin, 0)
                begin = memory_map.map_address(begin)
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

        elif 'itemSize' in asset_definition:
            # fixed item size
            item_size = asset_definition['itemSize']
            if isinstance(item_size, str):
                item_size = int(item_size, 0)
            assert len(asset_data) % item_size == 0, \
                'Fixed-length array size mismatch'
            array_length = len(asset_data) // item_size
            for i in range(array_length):
                pointer_list.append(i * item_size)

        else:
            raise ValueError('Unable to determine array item size')

        # remove duplicates and sort pointers
        sorted_pointers = sorted(set(pointer_list))

        # create a list of pointer ranges (these don't correspond with item
        # ranges for terminated and sequential items)
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

        # generate inc and asm files
        self.write_asset_asm(key, asset_data, pointer_list)

        # generate asset files
        try:
            asset_path = asset_definition['assetPath']
        except KeyError:
            raise KeyError('Missing asset path')

        if asset_definition['type'] == 'array':
            # create each array item
            if 'assembly' not in asset_definition:
                raise ValueError('Missing array prototype assembly')
            item_definition = asset_definition['assembly']

            array = []
            for item_range in item_ranges:
                item_data = asset_data[item_range.begin:item_range.end + 1]
                array.append(self.extract_object(item_data, item_definition))

            asset_path_split = os.path.splitext(asset_path)
            if asset_path_split[1] == '.json':
                # write the entire array to a single json file
                asset_json = json.dumps(array, ensure_ascii=False, indent=2)
                os.makedirs(os.path.dirname(asset_path), exist_ok=True)
                with open(asset_path, 'w') as f:
                    f.write(asset_json)

            else:
                # write each array item to a separate file
                if 'itemKeys' in asset_definition:
                    # custom item keys
                    item_keys = asset_definition['itemKeys']
                else:
                    # default item keys
                    item_keys = []

                for i in range(array_length):
                    if i < len(item_keys):
                        item_key = item_keys[i]
                    else:
                        item_key = str(i)
                    item_path = asset_path.replace('%s', item_key)
                    os.makedirs(os.path.dirname(item_path), exist_ok=True)
                    with open(item_path, 'wb') as f:
                        f.write(array[i])

        else:
            obj = self.extract_object(asset_data, asset_definition)

            # save the asset data
            asset_path_split = os.path.splitext(asset_path)
            if asset_path_split[1] == '.json':
                # write the asset to a json file
                asset_json = json.dumps(obj, ensure_ascii=False, indent=2)
                os.makedirs(os.path.dirname(asset_path), exist_ok=True)
                with open(asset_path, 'w') as f:
                    f.write(asset_json)

            else:
                os.makedirs(os.path.dirname(asset_path), exist_ok=True)
                with open(asset_path, 'wb') as f:
                    f.write(obj)

    def write_json_asset(self, key, obj):
        # write the asset to a json file
        asset_definition = self.get_asset_definition(key)
        asset_path = asset_definition['assetPath']
        asset_json = json.dumps(obj, ensure_ascii=False, indent=2)
        os.makedirs(os.path.dirname(asset_path), exist_ok=True)
        with open(asset_path, 'w') as f:
            f.write(asset_json)

    def extract_object(self, obj_bytes, obj_definition):

        if 'format' in obj_definition:
            # decode the data
            data_codec = rt.DataCodec(obj_definition['format'])
            obj_bytes = data_codec.decode(obj_bytes)

        if obj_definition['type'] == 'assembly':
            obj = {}
            sub_definition_list = obj_definition['assembly']
            for key in sub_definition_list:
                sub_definition = sub_definition_list[key]

                # skip category names
                if isinstance(sub_definition, str):
                    continue

                # skip external properties
                if sub_definition.get('external', False):
                    continue

                if 'range' in sub_definition:
                    # get a slice of the object data
                    sub_range = rt.Range(sub_definition['range'])
                    sub_bytes = obj_bytes[sub_range.begin:sub_range.end + 1]
                else:
                    sub_bytes = obj_bytes

                obj[key] = self.extract_object(sub_bytes, sub_definition)

            return obj

        elif obj_definition['type'] == 'text':
            encoding_key = obj_definition['encoding']
            return self.text_codecs[encoding_key].decode_text(obj_bytes)

        elif obj_definition['type'] == 'property':
            return self.extract_property(obj_bytes, obj_definition)

        elif obj_definition['type'] == 'array':
            return self.extract_array(obj_bytes, obj_definition)

        else:
            return obj_bytes

    def extract_property(self, obj_bytes, obj_definition):
        # calculate the index of the first bit
        mask = obj_definition.get('mask', 0xFF)
        if isinstance(mask, str):
            mask = int(mask, 0)
        bitIndex = 0
        firstBit = 1
        while (firstBit & mask) == 0:
            bitIndex += 1
            firstBit <<= 1

        value = 0
        begin = obj_definition.get('begin', 0)
        if isinstance(begin, str):
            begin = int(begin, 0)
        end = min(begin + 5, len(obj_bytes))
        for i in reversed(range(begin, end)):
            value <<= 8
            value |= obj_bytes[i]

        value = (value & mask) >> bitIndex
        if obj_definition.get('bool', False):
            # convert to bool
            value = (value != 0)

        return value

    def extract_array(self, array_bytes, array_definition):
        array = []
        try:
            prototype = array_definition['assembly']
        except KeyError:
            raise ValueError('Sub-array definition has no prototype assembly')

        terminator = array_definition.get('terminator', None)
        if terminator == '\\0':
            # null-terminated text
            try:
                encodingKey = prototype['encoding']
            except KeyError:
                raise ValueError('Null-terminated text has no encoding')

            textCodec = self.textCodec[encodingKey]
            begin = 0
            while begin < len(array_bytes):
                end = begin + textCodec.text_length(array_bytes[begin:])
                item_bytes = array_bytes[begin:end]
                item_obj = self.extract_object(item_bytes, prototype)
                array.append(item_obj)
                begin = end

        elif terminator != None:
            # terminated items
            if isinstance(terminator, str):
                terminator = int(terminator, 0)
            begin = 0
            end = 0
            while end < len(array_bytes):
                if array_bytes[end] == terminator:
                    item_bytes = array_bytes[begin:end + 1]
                    item_obj = self.extract_object(item_bytes, prototype)
                    array.append(item_obj)
                    begin = end + 1
                end += 1

            # data at end with no terminator
            if begin != end:
                raise Exception('Invalid terminated array item')

        elif 'itemSize' in array_definition:
            # fixed length items
            item_size = array_definition['itemSize']
            assert len(array_bytes) % item_size == 0, \
                'Fixed-length array size mismatch'
            begin = 0
            while begin < len(array_bytes):
                item_bytes = array_bytes[begin:begin + item_size]
                item_obj = self.extract_object(item_bytes, prototype)
                array.append(item_obj)
                begin += item_size

        else:
            raise ValueError('Invalid sub-array')

        return array

    def write_asset_asm(self, asset_key, asset_bytes, item_offsets):

        asset_definition = self.get_asset_definition(asset_key)
        asm_symbol = asset_definition['asmSymbol']

        inc_path = f'{self.include_dir}/{asset_key}.inc'

        # file header
        inc_string = '.list off\n\n'
        inc_string += '; this file is generated automatically,' \
            + ' do not modify manually\n\n'

        # include guard
        inc_string += f'.ifndef {asm_symbol}_INC\n'
        inc_string += f'{asm_symbol}_INC = 1\n\n'

        # import/export asset symbol
        inc_string += f'.global {asm_symbol}\n'

        # import/export asset pointer table
        if 'pointerTable' in asset_definition:
            inc_string += f'.global {asm_symbol}Ptrs\n'
        inc_string += '\n'

        # define asset size
        inc_string += f'.define {asm_symbol}_SIZE '
        size_str = rt.hex_string(len(asset_bytes), 4, "$").lower()
        inc_string += f'{size_str}\n'

        # define asset array length and item size
        if asset_definition['type'] == 'array':
            inc_string += f'.define {asm_symbol}_ARRAY_LENGTH '
            inc_string += f'{len(item_offsets)}\n'
            if 'itemLength' in asset_definition:
                item_length = asset_definition['itemLength']
                if isinstance(item_length, str):
                    item_length = int(item_length, 0)
                inc_string += f'.define {asm_symbol}_ITEM_SIZE '
                inc_string += f'{item_length}\n'
        inc_string += '\n.endif\n'
        inc_string += '.list on\n'

        # save asset include file
        os.makedirs(os.path.dirname(inc_path), exist_ok=True)
        with open(inc_path, 'w') as f:
            f.write(inc_string)

        # generate the assembly file
        asm_path = f'{self.include_dir}/{asset_key}.asm'

        # file header
        asm_string = '.list off\n\n'
        asm_string += '; this file is generated automatically,' \
            + ' do not modify manually\n'

        # asset label
        asset_labels = [(0, f'{asm_symbol}')]

        # generate a list of labels for each pointer
        if asset_definition['type'] == 'array' and \
                'format' not in asset_definition:
            for i, begin in enumerate(item_offsets):
                # generate a label
                index_string = rt.hex_string(i, 4, '').lower()
                item_label = f'{asm_symbol}_{index_string}'
                asset_labels.append((begin, item_label))

        asm_string += rt.bytes_to_asm(asset_bytes, labels=asset_labels)
        asm_string += '\n\n.list on\n'

        # save asset assembly file
        os.makedirs(os.path.dirname(asm_path), exist_ok=True)
        with open(asm_path, 'w') as f:
            f.write(asm_string)
