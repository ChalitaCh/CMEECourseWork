#!/bin/bash
# Author: Chalita Chomkatekaew chalita.chomkatekaew20@imperial.ac.uk
# Script: run_get_TreeHeight.sh
# Description:  UNIX shell script to test the get treeheight R script
# Saves the output into the a csv file
# Date: 6 Oct 2021

#Create a variable for an input file
Inputfile='../data/trees.csv'

#Run the get_Treeheights.R

Rscript get_TreeHeight.R ${Inputfile}

