#!/usr/bin/env python3

from random import shuffle
import numpy as np
import os
import sys

rng_path = sys.argv[1]
assert os.path.exists(rng_path), f"RNG file doesn't exist: {rng_path}"
rng_tbl = np.fromfile(rng_path, dtype=np.uint8)
shuffle(rng_tbl)
rng_tbl.tofile(rng_path)
