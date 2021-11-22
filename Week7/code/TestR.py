#!/usr/bin/env python3

"""
This is an example script for creating a workflow with other scripts using python,
subprocess package. In this script, TestR.R is called and the output and the error files are saved accordingly.
"""

__author__ = 'Chalita Chomkatekaew chalita.chomkatekaew20@ic.ac.uk'
__version__ = '0.0.1'


import subprocess

subprocess.Popen("Rscript --verbose TestR.R > ../results/TestR.Rout 2> ../results/TestR_errFile.Rout", shell = True).wait()