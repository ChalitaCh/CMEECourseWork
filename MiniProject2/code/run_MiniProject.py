#!/usr/bin/env python3
"""This script is to run a workflow of my miniproject"""

__appname__ = 'run_MiniProject.py'
__author__ = 'Chalita Chomkatekaew cc2320@ic.ac.uk'
__version__ = '0.0.1'

## import

import subprocess

## code

print('Cleaning the data')
#subprocess.Popen("Rscript --verbose DataCleaning.R > ../results/log_dataclean.log 2> ../results/log_dataclean.err", shell=True).wait()

print('Fitting the model and optimising the starting values')
#subprocess.Popen("Rscript --verbose Model_fittings.R > ../results/log_modelfitting.log 2> ../results/log_modelfitting.err", shell=True).wait()

print('Analysing the data')
#subprocess.Popen("Rscript --verbose Model_selection_analysis.R > ../results/log_model_analysis.log 2> ../results/log_modelanalysis.err", shell=True).wait()

print('Plotting the beautiful graphs!')
subprocess.Popen("Rscript --verbose Data_visualisation.R > ../results/log_datavis.log 2> ../results/log_datavis.err", shell=True).wait()

print('Compile a report')

subprocess.Popen("bash CompileLaTex.sh MiniprojectReport.tex > ../results/log_compile.log 2> ../results/log_compile.err", shell=True).wait()


print('Done!')