#!/usr/bin/env python3

"""
This script is to illustrate the profiling in Python by comparing
the two scripts profileme.py vs profileme2.py using timeit package
"""

__author__ = 'Chalita Chomkatekaew chalita.chomkatekaew20@ic.ac.uk'
__version__ = '0.0.1'


##############################################################################
# loops vs. list comprehensions: which is faster?
##############################################################################

iters = 100000

import timeit

from profileme import my_squares as my_squares_loops

from profileme2 import my_squares as my_squares_lc

##############################################################################
# loops vs. the join method for strings: which is faster?
##############################################################################

mystring = "my string"

from profileme import my_join as my_join_join

from profileme2 import my_join as my_join

#%timeit my_squares_loops(iters)
#%timeit my_squares_lc(iters)
#%timeit (my_join_join(iters, mystring))
#%timeit (my_join(iters, mystring))

"""
To use the timeit command, the command needs to be called in the ipython terminal as
shown above. Calling it within the script would not work.

For more simpler approach, please use the following the commands from time package.
This can be run as a whole script.

import time
start = time.time()
my_squares_loops(iters)
print("my_squares_loops takes %f s to run." % (time.time() - start))

start = time.time()
my_squares_lc(iters)
print("my_squares_lc takes %f s to run." % (time.time() - start))

"""


