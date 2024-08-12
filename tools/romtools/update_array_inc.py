import os
import romtools as rt

'''
Write offsets for the items in an array into an include file.
'''

ASM_INDENT = ' ' * 8

def update_array_inc(asset_bytes, item_ranges, **kwargs):

    if 'inc_path' not in kwargs:
        return

    inc_path = kwargs['inc_path']
    assert os.path.exists(inc_path), f'Missing include file: {inc_path}'

    # get the asset label
    assert 'asset_label' in kwargs, 'Missing asset_label'
    asset_label = kwargs['asset_label']

    # define the number of items in the array
    inc_text = ASM_INDENT + f'ARRAY_LENGTH = {len(item_ranges)}\n'

    if 'item_size' in kwargs:
        # fixed item size
        inc_text += ASM_INDENT + f'ITEM_SIZE = '
        inc_text += str(kwargs['item_size']) + '\n'
        inc_text += ASM_INDENT + 'SIZE = ARRAY_LENGTH * ITEM_SIZE\n'
    else:
        # variable item size
        inc_text += ASM_INDENT + f'SIZE = {len(asset_bytes)}\n\n'

        # define item offsets
        for id, item_range in enumerate(item_ranges):
            inc_text += ASM_INDENT + '_%d := ' % id
            inc_text += f'{asset_label} + $%04x\n' % item_range.begin

    # update item offsets in the include file
    rt.insert_asm(inc_path, inc_text)
