# CMEE 2021 HPC excercises R code HPC run code pro forma

rm(list=ls()) # good practice 
graphics.off() #clear the graphics

#Load the functions
source("cc2320_HPC_2021_main.R")

#read the job number

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

#set the random number for seed
  
set.seed(iter)

#set the size of the population in each iteration
  
  if(iter >= 1 & iter <= 25){
    size <- 500
  } else if (iter >= 26 &iter <= 50){
    size <- 1000
  } else if (iter >=51 & iter <= 75){
    size <- 2500
  } else {
    size <- 5000
  }

#create a name of output file

output <- paste("stimulation_cluster_run_out_",iter,".rda",sep = "")
  
cluster_run(speciation_rate = 0.0033275,
              size,
              wall_time = (11.5*60),
              interval_rich = 1,
              interval_oct = size/10,
              burn_in_generations = 8*size,
              output_file_name = output)





