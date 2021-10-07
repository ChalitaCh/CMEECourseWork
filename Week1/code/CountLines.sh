#!/bin/bash

# < will just catch the numerical output
NumLines=$(wc -l < $1)
echo "The file $1 has $NumLines lines"
echo
