#!/usr/bin/env python3

"""Testing the loops in different formats"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

# FOR loops in Python
for i in range(5):
    print(i)

# A list of variable
my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

# Loops with 2 lists of variables
total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)

"""Testing the WHILE loop in different formats"""

# WHILE loops in Python
z = 0
while z < 100: #Condition has to be true for the following command to invoke
    z = z + 1
    print(z) #print a number from 1..100

b = True
while b:
    print("GERONIMO! infinite loop! ctrl+c to stop!")


