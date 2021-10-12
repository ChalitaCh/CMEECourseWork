#!/bin/bash
# Author: Chalita Chomkatekaew cc2320@ic.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
#
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2021

echo "Creating a comma delimited version of $1 ..."
if [ $# -eq 0 ]
then
	echo "Please supply a tab delimited file as an input"
else
	cat $1 | tr -s "\t" ","  >> ${1/.txt/}.csv
	echo "Done!"
	exit
fi
