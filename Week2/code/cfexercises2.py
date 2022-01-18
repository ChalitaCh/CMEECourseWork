#!/usr/bin/env python3

"""This is an example script explaining more about loops and conditionals combined"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

########################
def hello_1(x):
    """For loop with if condition"""
    for j in range(x):
        if j % 3 == 0:
            print('hello')
    print(' ')

hello_1(12)

########################
def hello_2(x):
    """For loop with 2 conditions"""
    for j in range(x):
        if j % 5 == 3:
            print('hello')
        elif j % 4 == 3:
            print('hello')
    print(' ')

hello_2(12)

########################
def hello_3(x, y):
    """For loop with a specific range of values"""
    for i in range(x, y):
        print('hello')
    print(' ')

hello_3(3, 17)

########################
def hello_4(x):
    """While loop"""
    while x != 15:
        print('hello')
        x = x + 3 #while loop will stop when the condition is FALSE
    print(' ')

hello_4(0)

########################
def hello_5(x):
    """While loop with 2 if condition"""
    while x < 100:
        if x == 31:
            for k in range(7):
                print('hello')
        elif x == 18:
            print('hello')
        x = x + 1 #add the x with 1 in each loop
    print(' ')

hello_5(12)

########################
def hello_6(x, y):
    """While loop with break when condition met"""
    while x: #while x is TRUE
        print("hello!" + str(y))
        y +=1 # increment y by 1
        if y == 6:
            break
    print(' ')

hello_6(True, 0)