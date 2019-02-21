#!/usr/bin/env python3

import sys
import os
from utils import *
from assemble import *


def main():
    if len(sys.argv) != 2:
        eprint("Usage: {} [ASM FILE]".format(sys.argv[0]))
        sys.exit(1)
    if os.environ.get("DEBUG"):
        dprint.enable()
    fin = open(sys.argv[1], "r")
    fout = open(get_object_filename(sys.argv[1]), "wb")
    sym_table, start_addr = first_pass(fin)
    second_pass(fin, fout, sym_table, start_addr)


if __name__ == "__main__":
    main()