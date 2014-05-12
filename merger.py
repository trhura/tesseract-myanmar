#! /usr/bin/env python3
"""
Main module
"""
import sys
import itertools

def main():
    """
    Main function
    """

    if len(sys.argv) != 3:
        print("Usage:", sys.argv[0], "boxfile txtfile")
        sys.exit(-1)

    boxfile = sys.argv[1]
    txtfile = sys.argv[2]

    with open(boxfile, 'r') as box_file, open(txtfile, 'r') as txt_file:
        for b, t in itertools.zip_longest(box_file, txt_file):
            b = b.strip()
            b = b.split()
            t = t.strip()
            b[0] = t
            print(" ".join(b))

if __name__ == "__main__":
    main()
