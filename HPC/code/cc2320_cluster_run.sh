#!/bin/bash

#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb

#Start of the script

module load anaconda3/personal

echo "R is about to run"

cp $HOME/cc2320_HPC_2021_main.R .

R --vanilla < $HOME/cc2320_HPC_2021_cluster.R

mv stimulation_cluster_run_out_* $HOME

echo "R has finished running"

#End of the script
