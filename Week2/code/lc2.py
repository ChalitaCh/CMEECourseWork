#!/usr/bin/env python3

"""This script is a second exercise using list comprehension of rainfall variable 
to create two lists in combination with if conditions"""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk'
__version__ = '0.0.1'

## Constants ##

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.


## First exercise

# list comprehension of the months and amount of rain 
# where the amount of rain was greater than 100 mm.

rain_more_100 = [more for more in rainfall if more[1] > 100]
print(rain_more_100)

## Second exercise

# list comprehension of months where the amonth of rain was less than 50 mm.

rain_less_50_month = [less[0] for less in rainfall if less[1] < 50]
print(rain_less_50_month)


## Third exercise

# Convensional loops of the first two exercises.

rain_more_100 = [] #Creat an empty list to store the output
for more in rainfall:
    if more[1] > 100: #True if the amount of rain > 100
        rain_more_100.append(more)
print(rain_more_100)

rain_less_50_month = [] #Creat an empty list to store the output
for less in rainfall:
    if less[1] < 50: 
        rain_less_50_month.append(less[0]) #only append the first index, which is the month.
print(rain_less_50_month)
