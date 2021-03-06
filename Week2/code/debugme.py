#!/usr/bin/env python3

"""This script illustrates the process of debugging code in python"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

def buggyfunc(x):
    """Function to catch specific types of errors using try and except"""
    y = x
    for i in range(x):
        try:
            y = y - 1
            z = x / y
        except ZeroDivisionError:
            print(f"The result of dividing a number by zero is undefined")
        except:
            print(f"This didn't work; x = {x}; y = {y}")
        else:
            print(f"OK; x = {x}, y = {y}, z = {z};")
    return z

#call the function
buggyfunc(20)
