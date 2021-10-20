
#!/usr/bin/env python3

"""This script is showing how to store and load a data into a pickle file"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

#######################
# STORING OBJECTS
#######################
# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}


import pickle

f = open('../sandbox/testp.p', 'wb') ## note the b: accept binary files
pickle.dump(my_dictionary, f) ##save a dictionary into a pickle file AKA f
f.close()

## Load the data again
f = open('../sandbox/testp.p', 'rb') 
another_dictionary = pickle.load(f) ##load a dictionary from a pickle file stored in f
f.close()

print(another_dictionary)
