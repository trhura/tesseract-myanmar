#! /usr/bin/env python3
"""Ignore this"""

import sys
import unicodedata

def ismyconsonant (wc):
    LETTER_KA = u'\u1000'
    LETTER_A = u'\u1021'
    return (wc >= LETTER_KA) and (wc <= LETTER_A)

def ismy(wc):
    return (wc >= u'\u1000') and (wc <= u'\u104F')

def mmstrip(string):
    return "".join(filter(ismy, string))

def main():
    """ P """

    def mmc(s):
        return unicodedata.lookup(s)

    clusters = set()
    with open(sys.argv[1], 'r') as input_file:
        for line in input_file:
            line = line.strip()
            line = mmstrip(line)

            line = line.replace(mmc('MYANMAR VOWEL SIGN E'), '')
            line = line.replace(mmc('MYANMAR SIGN VISARGA'), '')
            consonants = list(filter(ismyconsonant, line))

            if len(consonants) == 1:
                    clusters.add(line)
            elif len(consonants) == 2:
                cpos = -1
                for i, char in enumerate(line[1:]):
                    if ismyconsonant(char):
                        cpos = i + 1
                clusters.add(line[0:cpos])
                clusters.add(line[cpos:])

        for clus in clusters:
            # if mmc('MYANMAR CONSONANT SIGN MEDIAL RA') in clus or \
            #    mmc('MYANMAR CONSONANT SIGN MEDIAL YA') in clus:
            #     vowel_u = clus.find(mmc('MYANMAR VOWEL SIGN U'))
            #     vowel_uu = clus.find(mmc('MYANMAR VOWEL SIGN UU'))

            #     if vowel_u != -1 or vowel_uu != -1:
            #         continue

            print(clus)

main()
