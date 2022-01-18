#!/usr/bin/env python3

"""This script is an example of how to use list comprehension to create a list in comparison to
the convensional loop"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

## Finds just those taxa that are oak trees from a list of species

taxa = [  'Quercus robur',
          'Franxinus excelsior' ,
          'Pinus sylvestris' ,
          'Quercus cerris' ,
          'Quercus petraea',
          ]

def is_an_oak(name):
    """Function to identify species started with genus Quercus"""
    return name.lower().startswith('quercus ')

"""Using for loops to find the oak trees in the list"""

oaks_loops = set() #intialise the empty set
for species in taxa: #loop through each input dataset
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

"""Using for list comprehension to find the oak trees in the list"""

oaks_lc = set([species for species in taxa if is_an_oak(species)])

""" Get names in UPPER CASE using for loops """
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

""" Get names in UPPER CASE using list comprehensions """
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
