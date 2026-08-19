#!/usr/bin/env python3

from random import shuffle
import numpy as np
import sys

if __name__ == '__main__':
    rng_path = sys.argv[1]
    rng_tbl = np.arange(256, dtype=np.uint8)
    shuffle(rng_tbl)
    rng_tbl.tofile(rng_path)
