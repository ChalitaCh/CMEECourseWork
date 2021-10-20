
#!/usr/bin/env python3

"""This script is showing the steps to write an file output"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk)'
__version__ = '0.0.1'

#######################
# FILE OUTPUT
#######################
# Save the elements of a list to a file
list_to_save = range(100)

f = open('../sandbox/testout.txt','w')
for i in list_to_save:
    f.write(str(i) + '\n') ##Add a new line at the end

f.close()
