#!/bin/bash
# Author: Chalita Chomkatekaew cc2320@ic.ac.uk
# Script: csvtospace.sh
# Description: substitute the commas in the file with space
# Saves the output into the text file with space separated values
# Arguments: 1 -> commas separated file
# Date: 6 Oct 2021

echo "Creating a space separeted text file of $1 ....."
cat $1 | tr -u "," " " >> ../results/${1/.csv/}.txt
echo "Done"
exit 
