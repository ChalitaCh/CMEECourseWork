#!/usr/bin/env python3

"""This script illustrates how sys package works"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

#Importing package
import sys


print("This is the name of the script: ", sys.argv[0]) # First index (0) is the name of the file name
print("Number of arguments: ", len(sys.argv)) # how many arguments were input
print("The arguments are: ", str(sys.argv)) # what are those arguments
