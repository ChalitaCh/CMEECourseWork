#!/usr/bin/env python3

"""This script is a third exercise to swap keys and values
in a dictionary"""
__author__ = 'Chalita Chomkatekaew (chalita.chomkatekaew20@imperial.ac.uk'
__version__ = '0.0.1'

## Constants ##

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc.
#  OR,
# 'Chiroptera': {'Myotis lucifugus'} ... etc

##Solution

taxa_dic = {} #creat an empty dictionary for the output

for x, y in taxa:
        if  y in taxa_dic: #If y is already an a key in the taxa_dic
                taxa_dic[y].append(x) #then append x as a value
        else:
                taxa_dic[y] = [x] #otherwise y has x as an only value

#Printing new dictionary
print(taxa_dic)