#!/usr/bin/env python3

"""These functions are for the examples of arithmetic operators in python"""
__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

import sys

## return the value of x in a power of 0.5
def foo_1(x):
    return x ** 0.5 

## if x is more than y, return x otherwise return y
def foo_2(x, y):
    if x > y:
        return x
    return y 

## rearrange the input numbers with the x > y < z when meet the condition
def foo_3(x, y, z):
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z] 

## factorial calculation of x AKA x!
def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result 

## a recursive function that calculates the factorial of x AKA x*(x-1)!
def foo_5(x): 
    if x == 1:
        return 1
    return x * foo_5(x - 1)

## Calculate the factorial of x in a different way
def foo_6(x): 
    facto = 1
    while x >= 1:
        facto = facto * 1
        x = x - 1
    return facto

def main(argv):
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
