#!/usr/bin/env python3

"""This script prints the input data into output block by species"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species 
# 
# A nice example output is:
# 
# Latin name: Passerculus sandwichensis
# Common name: Savannah sparrow
# Mass: 18.7
# ... etc.

# Hints: use the "print" command! You can use list comprehensions!

# Conventional loop
def read_table():
    """Function to loop and print into the desired format"""
    for name in birds:
        print("Latin name: ", name[0])
        print("Common name: ", name[1])
        print("Mass: ", name[2])
    return None

#run and print the output
print(read_table())

#List comprehension methods

test = [print("Latin name: %s \n Common name: %s \n Mass: %s" % (name[0], name[1], name[2]))for name in birds]
