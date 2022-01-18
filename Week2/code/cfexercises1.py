#!/usr/bin/env python3

"""These functions are for the examples of arithmetic operators in python"""
__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

## Import
import sys

## Functions

def foo_1(x):
    """ return the value of x in a power of 0.5 """
    return x ** 0.5 


def foo_2(x, y):
    """ if x is more than y, return x otherwise return y """
    if x > y:
        return x
    return y 

def foo_3(x, y, z):
    """rearrange the input numbers with the x > y < z when meet the condition"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z] 

def foo_4(x):
    """factorial calculation of x A.K.A x!"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result 

def foo_5(x): 
    """a recursive function that calculates the factorial of x A.K.A x*(x-1)!"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x): 
    """Calculate the factorial of x in a different way"""
    facto = 1
    while x >= 1:
        facto = facto * 1
        x = x - 1
    return facto

## Main function

def main(argv):
    """Invoke the defined functions obove with default values"""
    print(foo_1(5))
    print(foo_2(5, 2))
    print(foo_3(10, 5, 2))
    print(foo_4(5))
    print(foo_5(5))
    print(foo_6(5))
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
