import os, traceback
import romtools as rt
from mfvitools.mml2mfvi import mml_to_akao


def akao_to_asm(data, channels, mfvi_labels, song_label):

    symbol_list = []
    label_list = []

    # add a symbol for the size of the song data
    symbol_list.append((0, '.word', 'SongEnd - Header'))

    # add labels and symbols for the start and end addresses
    label_list.append((2, 'Header'))
    label_list.append((0x26, 'SongStart'))
    label_list.append((len(data), 'SongEnd'))
    symbol_list.append((2, '.addr', 'SongStart'))
    symbol_list.append((4, '.addr', 'SongEnd'))

    # add symbols for channel start addresses
    for i in range(1, 9):
        # normal start
        label_list.append((channels[i], f'Channel{i}'))
        symbol_list.append((4 + i * 2, '.addr', f'Channel{i}'))
        # alternate start
        label_list.append((channels[i + 8], f'AltChannel{i}'))
        symbol_list.append((20 + i * 2, '.addr', f'AltChannel{i}'))

    for ref_offset in mfvi_labels:
        label_offset = mfvi_labels[ref_offset]
        label_str = rt.hex_string(label_offset, 4, '_').lower()
        label_list.append((label_offset, label_str))
        symbol_list.append((ref_offset, '.addr', label_str))

    # file header with song label
    asm_string = '.list off\n\n'
    asm_string += '; this file is generated automatically,' \
        + ' do not modify manually\n\n'
    asm_string += f'.proc {song_label}\n'
    asm_string += rt.bytes_to_asm(data, labels=label_list, symbols=symbol_list)
    asm_string += '\n\n.endproc\n\n.list on\n'

    return asm_string


def akao_sfx_to_asm(data, channels, sfx_label):

    # file header
    asm_string = '.list off\n\n'
    asm_string += '; this file is generated automatically,' \
        + ' do not modify manually\n'

    label_list = []

    # range for sfx channel 1
    range1 = rt.Range(0x26, channels[2] - 1)
    if not range1.is_empty():
        label_list.append((range1.begin - 0x26, f'{sfx_label}_1'))

    # range for sfx channel 2
    range2 = rt.Range(channels[2], channels[3] - 1)
    if not range2.is_empty():
        label_list.append((range2.begin - 0x26, f'{sfx_label}_2'))

    # convert bytes to asm text
    asm_string += rt.bytes_to_asm(data[0x26:], labels=label_list)
    asm_string += '\n\n.list on\n'

    return asm_string


if __name__ == '__main__':
    asm_dir = os.path.join(os.getcwd(), 'include', 'script')
    mml_dir = os.path.join(os.getcwd(), 'script', 'mml')
    sfx_dir = os.path.join(os.getcwd(), 'script', 'sfx')

    for file in os.listdir(sfx_dir):
        mml_path = os.path.join(sfx_dir, file)
        mml_filename = os.path.splitext(file)[0].lower()
        asm_filename = f'{mml_filename}.asm'
        asm_path = os.path.join(asm_dir, asm_filename)

        # skip if asm file is newer than mml
        if os.path.isfile(asm_path) and os.path.getmtime(
                asm_path) > os.path.getmtime(mml_path):
            continue

        mml = []
        # read mml file
        try:
            with open(mml_path, 'r') as f:
                mml = f.readlines()
        except IOError as e:
            print(f'Error reading file {mml_path}')
            print(e)

        # convert mml file to binary and create asm string
        try:
            sfx_label = f'SfxScript_{mml_filename.split("_")[-1]}'
            variants = mml_to_akao(mml)
            def_variant = variants['_default_']
            asm_string = akao_sfx_to_asm(def_variant[0], def_variant[1],
                                         sfx_label)
        except Exception:
            traceback.print_exc()

        # write asm file
        try:
            os.makedirs(os.path.dirname(asm_path), exist_ok=True)
            with open(asm_path, 'w') as f:
                f.write(asm_string)
            print(f'{asm_filename} created.')
        except IOError as e:
            print(f'Error writing file {asm_path}')
            print(e)

    for file in os.listdir(mml_dir):
        mml_path = os.path.join(mml_dir, file)
        mml_filename = os.path.splitext(file)[0].lower()
        asm_filename = f'{mml_filename}.asm'
        asm_path = os.path.join(asm_dir, asm_filename)

        # skip if asm file is newer than mml
        if os.path.isfile(asm_path) and os.path.getmtime(
                asm_path) > os.path.getmtime(mml_path):
            continue

        mml = []
        # read mml file
        try:
            with open(mml_path, 'r') as f:
                mml = f.readlines()
        except IOError as e:
            print(f'Error reading file {mml_path}')
            print(e)

        # convert mml file to binary and create asm string
        try:
            mml_label = f'SongScript_{mml_filename.split("_")[-1]}'
            variants = mml_to_akao(mml)
            def_variant = variants['_default_']
            asm_string = akao_to_asm(def_variant[0], def_variant[1],
                                     def_variant[2], mml_label)
        except Exception:
            traceback.print_exc()

        # write asm file
        try:
            asm_path = os.path.join(asm_dir, asm_filename)
            os.makedirs(os.path.dirname(asm_path), exist_ok=True)
            with open(asm_path, 'w') as f:
                f.write(asm_string)
            print(f'{asm_filename} created.')
        except IOError as e:
            print(f'Error writing file {asm_path}')
            print(e)