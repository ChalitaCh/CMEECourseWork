#!/usr/bin/env python3

"""
This script is to illustrate the profiling in Python by comparing
two methods in joining/appending the strings. The code to profile the script is
run -p the_name_of_script.py
"""

__author__ = 'Chalita Chomkatekaew chalita.chomkatekaew20@ic.ac.uk'
__version__ = '0.0.1'

def my_squares(iters):
    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out

def my_join(iters,string):
    out = ''
    for i in range(iters):
        out += string.join(", ")
    return out

def run_my_func(x, y):
    print(x, y)
    my_squares(x)
    my_join(x, y)
    return 0

run_my_func(10000000, "My string")