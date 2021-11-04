#!/bin/bash
#CompileLatex file for Florida practical
#Run the R script to produce the figures first

Rscript Florida.R

##Compiling the input latex file
 
pdflatex $1
bibtex ${1%.*}
pdflatex $1
pdflatex $1
evince ${1%.*}.pdf &


## Cleanup

rm *.aux
rm *.log
rm *.bbl
rm *.blg
