#!/usr/bin/env python3

"""
This script is for a debugging practical. The debug
is done by using a doctest as illustrated below
"""

__author__ = 'Chalita Chomkatekaew chalita.chomkatekaew20@ic.ac.uk'
__version__ = '0.0.1'

## Imports ##

import csv
from os import CLD_CONTINUED
import sys
import doctest
import re


#Define function
def is_an_oak(name):
    """Returns True if name is starts with 'quercus'

    >>> is_an_oak('Fagus sylvatica')
    False

    >>> is_an_oak('Quercuss robur')
    False

    >>> is_an_oak('Quercus robur')
    True

    """
    return True if re.search(r'\bquercus\b', name, re.IGNORECASE ) else False #Checking if the matched not a typo

## Main function ##

def main(argv): 
    """
    The main function will open the datafile as f and write a result to JustOaksData.csv,
    which is given as g variable. The species name which match the name - quercus will be stored
    and write into g
    """
    f = open('../data/TestOaksData.csv','r') 
    g = open('../data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    
    for row in taxa:
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0],row[1]])

    #oaks = set() #not use...removed

    f.close() #close the file opened
    g.close()    

    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)

doctest.testmod() #To run with the test

