#!/usr/bin/env python3

import json
import os
import sys
import romtools as rt


if __name__ == '__main__':

    asset_path = sys.argv[1]

    # read asset file
    with open(asset_path, 'r', encoding='utf8') as json_file:
        asset_def = json.load(json_file)

    # encode the text
    encoded_bytes, _ = rt.encode_text(asset_def)

    # write the encoded binary data to the data path
    asset_root, _ = os.path.splitext(asset_path)
    dat_path = asset_root + '.dat'
    with open(dat_path, 'wb') as f:
        f.write(encoded_bytes)
