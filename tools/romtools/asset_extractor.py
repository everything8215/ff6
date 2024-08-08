import romtools as rt
import json
import os
from ff6_lzss import *


class AssetExtractor:

    def __init__(self, rom_bytes, map_mode):
        self.rom_bytes = rom_bytes
        self.memory_map = rt.MemoryMap(map_mode)

    def extract_object(self, asset_range, **kwargs):

        # calculate the appropriate ROM range using the mapper
        unmapped_range = rt.Range(asset_range)
        mapped_range = self.memory_map.map_range(unmapped_range)

        # extract the asset data
        asset_bytes = self.rom_bytes[mapped_range.begin:mapped_range.end + 1]

        # make a list of pointers for each item in the asset
        pointer_list = []

        if 'ptr_range' in kwargs:
            # array with a pointer table
            is_mapped = kwargs.get('is_mapped', False)
            ptr_offset = kwargs.get('ptr_offset', 0)
            if isinstance(ptr_offset, str):
                ptr_offset = int(ptr_offset, 0)

            if not is_mapped:
                # map the pointer offset first, then add pointers
                ptr_offset = self.memory_map.map_address(ptr_offset)

            # extract the pointer table data
            ptr_range = rt.Range(kwargs['ptr_range'])
            ptr_range = self.memory_map.map_range(ptr_range)
            ptr_data = self.rom_bytes[ptr_range.begin:ptr_range.end + 1]
            ptr_size = kwargs.get('ptr_size', 2)
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
                    pointer = self.memory_map.map_address(pointer)
                pointer_list.append(pointer - mapped_range.begin)

        elif 'item_offsets' in kwargs:
            # items with specified offsets
            item_offsets = kwargs['item_offsets']
            array_length = len(item_offsets)
            for begin in item_offsets:
                if isinstance(begin, str):
                    begin = int(begin, 0)
                begin = self.memory_map.map_address(begin)
                pointer_list.append(begin - mapped_range.begin)

        elif 'terminator' in kwargs:
            # terminated items
            terminator = kwargs['terminator']
            if isinstance(terminator, str):
                terminator = int(terminator, 0)
            pointer_list.append(0)
            for p in range(len(asset_bytes) - 1):
                if asset_bytes[p] == terminator:
                    pointer_list.append(p + 1)
            array_length = len(pointer_list)

        elif 'item_size' in kwargs:
            # fixed item size
            item_size = kwargs['item_size']
            if isinstance(item_size, str):
                item_size = int(item_size, 0)
            assert len(asset_bytes) % item_size == 0, \
                'Fixed-length array size mismatch'
            array_length = len(asset_bytes) // item_size
            for i in range(array_length):
                pointer_list.append(i * item_size)

        else:
            # single object
            pointer_list.append(0)
            array_length = 1

        # remove duplicates and sort pointers
        sorted_pointers = sorted(set(pointer_list))

        # create a list of pointer ranges (these don't correspond with item
        # ranges for terminated and sequential items)
        pointer_ranges = {}
        for p, pointer in enumerate(sorted_pointers):
            begin = pointer
            if p == len(sorted_pointers) - 1:
                end = len(asset_bytes) - 1
            else:
                end = sorted_pointers[p + 1] - 1
            pointer_ranges[begin] = rt.Range(begin, end)

        # create ranges for each item
        item_ranges = []

        for i in range(array_length):
            begin = pointer_list[i]
            if 'terminator' in kwargs:
                # item range goes until terminator is found
                end = begin
                terminator = kwargs['terminator']
                if isinstance(terminator, str):
                    terminator = int(terminator, 0)
                while end < len(asset_bytes):
                    if asset_bytes[end] == terminator:
                        break
                    end = end + 1
                item_ranges.append(rt.Range(begin, end))

            elif kwargs.get('is_sequential', False):
                if i != array_length - 1:
                    # item range goes up to next sequential pointer
                    end = pointer_list[i + 1] - 1
                else:
                    # last item goes up to end of asset range
                    end = len(asset_bytes) - 1
                item_ranges.append(rt.Range(begin, end))

            else:
                # otherwise, item range is same as pointer range
                item_ranges.append(pointer_ranges[begin])

        return asset_bytes, item_ranges

    def write_asset_file(self, asset_bytes, asset_path):

        # create directories
        os.makedirs(os.path.dirname(asset_path), exist_ok=True)

        # decompress the data, if necessary
        if asset_path.endswith('.lz'):
            with open(asset_path[:-3], 'wb') as f:
                f.write(decode_lzss(asset_bytes))

        # save the raw data
        with open(asset_path, 'wb') as f:
            f.write(asset_bytes)

    def extract_text(self, json_path, asset_range, **kwargs):

        # read the json file
        with open(json_path, 'r', encoding='utf8') as json_file:
            asset_def = json.load(json_file)

        if 'item_size' in asset_def:
            kwargs['item_size'] = asset_def['item_size']

        asset_label = asset_def['asset_label']
        asset_root, _ = os.path.splitext(json_path)

        # check if the data file already exists
        dat_path = asset_root + '.dat'
        if os.path.exists(dat_path):
            return

        # extract the text from the ROM
        asset_bytes, item_ranges = self.extract_object(asset_range, **kwargs)

        # write data file
        print(f'{asset_range} -> {json_path}')
        self.write_asset_file(asset_bytes, dat_path)

        # check if an include file exists
        if 'inc_path' in asset_def:
            inc_path = asset_def['inc_path']
            assert os.path.exists(inc_path), f'Missing include file: {inc_path}'

            # define the size
            inc_text = f'        SIZE = {len(asset_bytes)}\n'

            # define the array length
            inc_text += f'        ARRAY_LENGTH = {len(item_ranges)}\n'

            if 'item_size' in asset_def:
                # fixed item size
                inc_text += f'        ITEM_SIZE = '
                inc_text += str(asset_def['item_size']) + '\n'
            else:
                # define item offsets
                inc_text += '\n'
                for id, item_range in enumerate(item_ranges):
                    inc_text += '        _%d := ' % id
                    inc_text += f'{asset_label} + $%04x\n' % item_range.begin

            # update item offsets in the include file
            rt.insert_asm(inc_path, inc_text)

        # create the text codec
        char_table = {}
        for char_table_name in asset_def['char_tables']:
            char_table_path = 'tools/char_table/' + char_table_name + '.json'
            with open(char_table_path, 'r', encoding='utf8') as char_table_file:
                char_table.update(json.load(char_table_file))
        text_codec = rt.TextCodec(char_table)

        # decode the text strings
        text_list = []
        for item_range in item_ranges:
            item_bytes = asset_bytes[item_range.begin:item_range.end + 1]
            text_list.append(text_codec.decode_text(item_bytes))

        asset_def['text'] = text_list

        # write text strings to the asset file
        asset_json = json.dumps(asset_def, ensure_ascii=False, indent=2)
        with open(json_path, 'w', encoding='utf8') as f:
            f.write(asset_json)

    def extract_array(self, file_path, inc_path, asset_range, asset_label, **kwargs):

        # extract the array data from the ROM
        asset_bytes, item_ranges = self.extract_object(asset_range, **kwargs)

        if os.path.exists(file_path):
            return

        # write data file
        print(f'{asset_range} -> {file_path}')
        self.write_asset_file(asset_bytes, file_path)

        # check if an include file exists
        if os.path.exists(inc_path):

            # define the size
            inc_text = f'        SIZE = {len(asset_bytes)}\n'

            # define the array length
            inc_text += f'        ARRAY_LENGTH = {len(item_ranges)}\n'

            # define item offsets
            inc_text += '\n'
            for id, item_range in enumerate(item_ranges):
                inc_text += '        _%d := ' % id
                inc_text += f'{asset_label} + $%04x\n' % item_range.begin

            # update item offsets in the include file
            rt.insert_asm(inc_path, inc_text)


    def extract_asset(self, file_path, asset_range, **kwargs):

        # extract the asset from the ROM
        asset_bytes, item_ranges = self.extract_object(asset_range, **kwargs)

        # generate a list of file names
        if 'file_list' in kwargs:
            file_list = kwargs['file_list']
            assert len(file_list) == len(item_ranges)
        else:
            file_list = [('%04x' % i) for i in range(len(item_ranges))]
        path_list = [
            file_path.replace('%s', file_list[i])
            for i in range(len(item_ranges))
        ]

        extracted_one = False
        for i, item_range in enumerate(item_ranges):
            if os.path.exists(path_list[i]):
                continue
            if item_range.is_empty() or item_range.begin < 0:
                continue
            if not extracted_one:
                extracted_one = True
                print(f'{asset_range} -> {file_path}')
            gfx_bytes = asset_bytes[item_range.begin:item_range.end + 1]
            self.write_asset_file(gfx_bytes, path_list[i])
