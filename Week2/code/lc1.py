#!/usr/bin/env python3

"""This script is the first exercise using the list comprehension to generate
three different lists of birds, which consists of latin names,
common names, and body mass."""

__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk'
__version__ = '0.0.1'

## Constants ##

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.

## First exercise
# Creating three different lists of birds using list comprehension

#List of the latin names
Latin_names = [row[0] for row in birds]
print(Latin_names)

#List of the common names
Common_names = [row[1] for row in birds]
print(Common_names)

#List of the body mass
Body_mass = [row[2] for row in birds]
print(Body_mass)

## Second exercise
# Creating three different lists of birds using a convensional loop

#List of the latin names
Latin_names = []
for row in birds:
    Latin_names.append(row[0])
print(Latin_names)

#List of the common names
Common_names = []
for row in birds:
    Common_names.append(row[1])
print(Common_names)

#List of the body mass
Body_mass = []
for row in birds:
    Body_mass.append(row[2])
print(Body_mass)




 
