#!/usr/bin/env python3

"""This script is for aligning the two DNA sequences"""

__appname__ = '[ALIGN SEQS]'
__author__ = 'Chalita Chomkatekaew chalita.chomkatekaew20@imperial.ac.uk'
__version__ = '0.0.1'

## import

import sys
import csv

# Two example sequences to match
#seq2 = "ATCGCCGGATTACGGG"
#seq1 = "CAATTCGGAT"

## import the input sequences from a csv file
print("Aligning the DNA sequences....")

x = "../data/Exampleseq.csv"
temp = []
with open(x, "r") as seq:
    csvseq = csv.reader(seq)
    for row in csvseq:
        temp.append(row[1])

print()
print("This is a first input sequence: %s \n This is a second input sequence: %s" % (temp[0], temp[1]) )
print()

seq1 = temp[0]
seq2 = temp[1]

## function
# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint): # it will run with the startpoint of 0 if not specify
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"
    # some formatted output
    print("." * startpoint + matched) # "." * startpoint means how many time "*" is repeated based on the number of startpoint          
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

    # now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1
    
for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing!
        my_best_score = z 
print(my_best_align)
print(s1)
print("Best score:", my_best_score)

output = open("../results/best_align_seq_result.txt", "w")
output.write("The best alignment" + "\n" + my_best_align + "\n" + s1 + "\n" + "Best score:" + my_best_score)
output.close()

# Test the function with some example starting points:
def main(argv):
    print("Done!")
    return None

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)

