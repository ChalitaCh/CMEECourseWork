#!/bin/bash
# Author: Chalita Chomkatekaew chalita.chomkatekaew20@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Description: Merge two files together
# Saves the output into a specified file name -> 3
# Arguments: 1 and 2 -> any files
# Date : 11 Oct 2021

echo "Merging $1 and $2 to $3...."
if [[ $# < 3 ]]
then
	echo "This script requires 3 input arguments, please supply the input files"
else
 	cat $1 > $3
	cat $2 >> $3
	echo "Merged File is"
	cat $3
	exit 1
fi
