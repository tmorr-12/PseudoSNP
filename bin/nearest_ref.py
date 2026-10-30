#!/usr/bin/env python3

import sys
import pandas as pd

if __name__ == "__main__":
    mash_file = sys.argv[1]
    df = pd.read_csv(mash_file, sep="\t", index_col=None, header=None)
    df = df.sort_values(by=2, ignore_index=True)
    print(df.loc[0][0])
