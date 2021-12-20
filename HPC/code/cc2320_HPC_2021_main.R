# CMEE 2021 HPC excercises R code main pro forma
# you don't HAVE to use this but it will be very helpful.  If you opt to write everything yourself from scratch please ensure you use EXACTLY the same function and parameter names and beware that you may loose marks if it doesn't work properly because of not using the proforma.

name <- "Chalita Chomkatekaew"
preferred_name <- "Chalita"
email <- "chalita.chomkatekaew20@imperial.ac.uk"
username <- "cc2320"

# please remember *not* to clear the workspace here, or anywhere in this file. If you do, it'll wipe out your username information that you entered just above, and when you use this file as a 'toolbox' as intended it'll also wipe away everything you're doing outside of the toolbox.  For example, it would wipe away any automarking code that may be running and that would be annoying!

# Question 1
species_richness <- function(community){
  x <- length(unique(community))
  return(x)
}

# Question 2
init_community_max <- function(size){
  x <- seq(1, size)
  return(x)

}

# Question 3
init_community_min <- function(size){
  x <- rep(1, size)
  return(x)
  
}

# Question 4
choose_two <- function(max_value){
  x <- sample(1:max_value, 2, replace = FALSE) #pick 2 random numbers
  return(x)
}

# Question 5
neutral_step <- function(community){
  x <- choose_two(length(community)) 
  #replace the community index x[1] with individuals corresponding with the second index x[2]
  new <- replace(community,x[1], community[x[2]]) 
  return(new)
  
}

# Question 6
neutral_generation <- function(community){
  gen <- length(community)/2
  
  if (gen %% 2 != 0){ #if the generation is not a whole number
    
    random <- runif(1, min = 0, max =1) #randomly choose one number between 0-1
    
    if (random > 0.5){
      ceiling(gen) #round up
    } else {
      floor(gen) #round down
    }
  } 
  
  for (i in 1:gen){
    community <- neutral_step(community)
    
  }
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  time_series_comm <- species_richness(community)
  
  for (i in 1:duration){
    community <- neutral_generation(community)
    richness <- species_richness(community)
    time_series_comm <- c(time_series_comm, richness)
  }
  return(time_series_comm)
}

# Question 8
question_8 <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  comm <- init_community_max(100)
  gen <- c(200)
  richness_series <- neutral_time_series(community = comm, duration = gen)
  time <- seq(0, gen) #create a time vector
  plot(time, richness_series, type = "s",
       ylab = "Species richness",
       xlab = "Generations",
       main = "Species richness over time")
  return("Given no variation events occur, the species richness will always converge to one owing to the stochatic events")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  #randomly choose one number for speciation
  speciation <- runif(1, min = 0, max =1)
  
  if (speciation <= speciation_rate){ #if random speciation is less than or equal to the input rate
    x <- sample(1:length(community),1) #choosing the index of individual to die
    new_spec <- max(community) + 1 #create a new species that not in the community before
    new_comm <- replace(community, x , new_spec) #replace the died individual by new species
  } else {
    new_comm <- neutral_step(community)
  }
  return(new_comm)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  gen <- length(community)/2
  
  if (gen %% 2 != 0){
    random <- runif(1, min =1, max =1)
    if (random > 0.5){
      ceiling(gen)
    } else {
      floor(gen)
    }
  } 
  
  for (i in 1:gen){
    new <- neutral_step_speciation(community, speciation_rate)
    community <- new
  }
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  time_series_comm <- species_richness(community)
  
  for (i in 1:duration){
    community <- neutral_generation_speciation(community, speciation_rate)
    richness <- species_richness(community)
    time_series_comm <- c(time_series_comm, richness)
  }
  return(time_series_comm)
}

# Question 12
question_12 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  comm_max <- init_community_max(100)
  comm_min <- init_community_min(100)
  gen <- c(200)
  time <- seq(0, gen)
  rate <- c(0.1)
  max_series <- neutral_time_series_speciation(comm_max,rate,gen)
  min_series <- neutral_time_series_speciation(comm_min,rate,gen)
  
  #create a data frame for each community for plotting graph
  max <- data.frame(time,max_series)
  min <- data.frame(time,min_series)
  
  plot(max$time, max$max_series,
       type = "l",
       ylab = "Species richness",
       xlab = "Generations",
       col = "red",
       ylim = c(0,100),
       main = "Species richness over time between two initial communites' conditions")
  
  #overlay with the line for initial minimum community
  
  lines(min$time, min$min_series,
        col = "blue")
  
  #plot the figure legend
  
  legend(x = 120, y = 80, legend = c("Initial maximum community", "Initial mininum community"),
         col = c("red", "blue"),
         box.lty = 0,
         lty = 1)
  

  return("Given the maximum possible species in the community, some species outcompetes another and cause the dramatic drop in species richness at the first few generations. Speciation could also cause such a reduction by introducing more fitted species.
         Whereas, in a single species population, the species richness is increasing by speciation. Ultimately, both populations reached the dynamic equilibrium where new species arises and some are extinct, resulting the oscillation pattern over time.")
}

# Question 13
species_abundance <- function(community)  {
  freq_table <- as.data.frame(table(community)) #create a frequency table and covert it to a data frame
  abundance <- sort(freq_table$Freq, decreasing = TRUE) #sort the frequency in decreasing order
  return(abundance)
}

# Question 14
octaves <- function(abundance_vector) {
  x <- floor(log(abundance_vector,2)) + 1 #log based 2
  octaves_results <- tabulate(x)
  return(octaves_results)
}

# Question 15
sum_vect <- function(x, y) {
  
  #find the length of the two vectors
  x_len <- length(x)
  y_len <- length(y)
  
  #if x vector has a longer length then assigned to a vector called longer and another to shorter
  if (x_len >= y_len){
    longer <- x
    shorter <- y
  } else {
    longer <- y
    shorter <- x
  }
  
  #find the shorter vector length
  
  max.len <- length(shorter)
  
  #initialise the empty vector to hold the result vector
  
  result_sum <-c()
  
  #if their lengths are not equal
  if (length(shorter) != length(longer)){ 
    
    #add all the elements of the two vectors only until the last element in the shorter vector
    sum <-shorter[1:max.len] + longer[1:max.len] 
    
    #find the different between the two vectors
    diff <- length(longer) - length(shorter)
    
    #create the vector of index to carry over from the longer vector
    add_index <- seq(length(shorter)+1, length(shorter) + diff)
    
    #add the sum and carried over vectors together
    result_sum <- c(sum, longer[min(add_index):max(add_index)])
    
  } else { #if the two vectors are equal length
    
    #just add up the two vectors normal way
    result_sum <- shorter + longer
  }
  return(result_sum)
}

# Question 16 
question_16 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  comm_max <- init_community_max(100)
  comm_min <- init_community_min(100)
  duration <- 2200
  burnin_gen <- 200
  spec_rate <- 0.1
  
  #find the community stages over the burn-in generations
  for (i in 1:burnin_gen){
    comm_max<- neutral_generation_speciation(comm_max, spec_rate)
    comm_min <-neutral_generation_speciation(comm_min, spec_rate)
  }
  
  #save the abundance octaves after the burn-in generations
  
  octaves_comm_max <- octaves(species_abundance(comm_max))
  octaves_comm_min <- octaves(species_abundance(comm_min))
  
  #continue the neutral generation speciation for 2000 further
  
  for (i in (burnin_gen+1):duration){
    
    comm_max <- neutral_generation_speciation(comm_max, spec_rate)
    comm_min <- neutral_generation_speciation(comm_min, spec_rate)
    
    #save the abundance octaves every 20 generations 
    
    if (i > burnin_gen & i%%20 == 0){

      octaves_comm_max_temp <- octaves(species_abundance(comm_max))
      octaves_comm_min_temp <- octaves(species_abundance(comm_min))
      
      octaves_comm_max <- sum_vect(octaves_comm_max, octaves_comm_max_temp)
      octaves_comm_min <- sum_vect(octaves_comm_min, octaves_comm_min_temp)
    }
  }
  
  #find the average number of species 
  
  max_mean <- octaves_comm_max/100
  min_mean <- octaves_comm_min/100
  
  #create a graph with 2 panels
  par(mfrow = c(1,2))
  
  barplot(min_mean, 
          xlab= "Abundance octaves",
          ylab = "Mean number of species",
          main = "A) Minimum initial community",
          ylim = c(0,10),
          names.arg = seq(1:length(max_mean)),#label the x axis
          col = c("#3FA0FF"))
  
  barplot(max_mean, 
          xlab= "Abundance octaves",
          ylab = "Mean number of species",
          main = "B) Maximum initial community",
          ylim = c(0, 10),
          names.arg = seq(1:length(min_mean)),
          col = c("#F76D5E"))
  
  mtext("Average species abundance over time between initial minimum and initial maximum communities",  # Add main title
        side = 3,
        line = - 1,
        outer = TRUE)
  
  return("The initial condition of the system does not matter in the measurement of species abundance over time when removing the population abundance during the burn-in generations.
         As reaching the dynamic equilibrium, the average of species abundance would be relatively the same. However, variations in species abundance could be observed with changes in parameters such as population size and speciation rate.")
}

# Question 17
cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name)  {
    comm <- init_community_min(size)
    run_time <- wall_time * 60 #Change the wall time unit, from minutes to seconds
    tm <- proc.time()[[3]] #start the timer - only elapsed time
    
    #create the empty vectors and list to keep the results
    richness <- c()
    oct <- list()
    generation <- 0
    
    #while the stimulation time is less than the set run time
    while (proc.time()[[3]] - tm < run_time){
      generation <- generation + 1
      comm <- neutral_generation_speciation(comm, speciation_rate)
      spec_rich <- species_richness(comm)
      
      
      if (generation %% interval_rich == 0){
        richness <- c(richness, spec_rich)
      }
      
      if (generation %% interval_oct == 0){
        oct[[length(oct) + 1]] <- octaves(species_abundance(comm))
      }
    }
    
    #find the total time of stimulation used
    end.time <- proc.time()[[3]] 
    total.time <- (end.time - tm)/60
  
  #save the outputs to the name of output file
  save(richness, oct,comm,total.time,speciation_rate,size,wall_time,interval_rich,interval_oct,burn_in_generations, file = paste(output_file_name)  )  
}

# Questions 18 and 19 involve writing code elsewhere to run your simulations on the cluster

# Question 20 
process_cluster_results <- function()  {
  
  #create a list of stimulation output files
  files <- list.files(pattern = "^stimulation_.*\\.rda$")
  
  #initialised the empty vectors to hold the outputs
  
  abundance_500 <- c()
  abundance_size_500 <- 0
  
  abundance_1000 <- c()
  abundance_size_1000 <- 0
  
  abundance_2500 <- c()
  abundance_size_2500 <- 0
  
  abundance_5000 <- c()
  abundance_size_5000 <- 0
  
  
  for (i in 1:100){
    load(files[i])
    
    
    #if the population size is 500
    if (size == 500){
      
      #find the octaves saved during the burn-in generations
      burnin <- burn_in_generations/interval_oct
      
      #find the length of generations after the burn-in generations
      abundance_size_500 <- length(oct) - burnin + abundance_size_500
      
      #add up the octaves after the burn-in generations
      for (j in (burnin + 1):length(oct))
        abundance_500 <- sum_vect(abundance_500,oct[[j]])
    }
    
    #repeat the same for each population size
    if (size == 1000){
      burnin <- burn_in_generations/interval_oct
      abundance_size_1000 <- length(oct) - burnin + abundance_size_1000
      for (j in (burnin + 1):length(oct))
        abundance_1000 <- sum_vect(abundance_1000,oct[[j]])
    }
    
    if (size == 2500){
      burnin <- burn_in_generations/interval_oct
      abundance_size_2500 <- length(oct) - burnin + abundance_size_2500
      for (j in (burnin + 1):length(oct))
        abundance_2500 <- sum_vect(abundance_2500,oct[[j]])
    }
    
    if (size == 5000){
      burnin <- burn_in_generations/interval_oct
      abundance_size_5000 <- length(oct) - burnin + abundance_size_5000
      for (j in (burnin + 1):length(oct))
        abundance_5000 <- sum_vect(abundance_5000,oct[[j]])
    }
  }
  
  #find the average abundance of each population size
  mean_500 <- abundance_500/abundance_size_500
  
  mean_1000 <- abundance_1000/abundance_size_1000
  
  mean_2500 <- abundance_2500/abundance_size_2500
  
  mean_5000 <- abundance_5000/abundance_size_5000
  
  combined_results <- list(mean_500, mean_1000, mean_2500, mean_5000) #create your list output here to return
  # save results to an .rda file
  save(combined_results, file = "combined_results.rda")
}

plot_cluster_results <- function()  {
    # clear any existing graphs and plot your graph within the R window
    # load combined_results from your rda file
    # plot the graphs
  graphics.off()
  load("combined_results.rda")
  par(mfrow = c(2,2))
  
  #create a vector to save a colour palette
  colour <- hcl.colors(length(combined_results), "Zissou 1")
  
  #plot the barplot of each population size
  barplot(combined_results[[1]],
          xlab = "Abundance octaves",
          ylab = "Mean number of species",
          main = "A) Community size 500",
          names.arg = seq(1:length(combined_results[[1]])),
          col = colour[1])
  barplot(combined_results[[2]],
          xlab = "Abundance octaves",
          ylab = "Mean number of species",
          main = "B) Community size 1000",
          names.arg = seq(1:length(combined_results[[2]])),
          col = colour[2])
  barplot(combined_results[[3]],
          xlab = "Abundance octaves",
          ylab = "Mean number of species",
          main = "C) Community size 2500",
          names.arg = seq(1:length(combined_results[[3]])),
          col = colour[3])
  barplot(combined_results[[4]],
          xlab = "Abundance octaves",
          ylab = "Mean number of species",
          main = "D) Community size 5000",
          names.arg = seq(1:length(combined_results[[4]])),
          col = colour[4])
  mtext("Stimulation results of average species abundance in different community sizes",  # Add main title
        side = 3,
        line = - 1,
        outer = TRUE)
  
    return(combined_results)
}

# Question 21
question_21 <- function()  {
  x <- log10(8)/log10(3)
  my_results <- c(x, "To be three times as wide, it needs 8 times of the material ")
  return(my_results)
}

# Question 22
question_22 <- function()  {
    x <- log10(20)/log10(3)
    my_results <- c(x, "For the cube to be three times as wide, it needs 20 cubes of the material")
  return(my_results)
}

# Question 23
chaos_game <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  A <- c(0,0)
  B <- c(3,4)
  C <- c(4,1)
  X <- c(0,0)
  
  coord <- list(A,B,C)
  
  #create a plot
  
  plot(X[1],X[2],cex = 0.01,
       xlim = c(0,5),
       ylim = c(0,5),
       xlab = "",
       ylab = "",
       xaxt = "n",
       yaxt = "n",
       main = "A Sierpinski gasket")
  
  for (i in 1:10000){
    
    #randomly pick a coordinate
    random <- sample(coord, size = 1)
    
    #add the X coordinate with half length of randomly coordinate
    X <- (X + random[[1]])/2
    
    #plot the point on the initialised plot
    points(X[1],X[2], cex = 0.5)
  }
  return("A Sierpinski gasket")
}

# Question 24
turtle <- function(start_position, direction, length)  {
  new_x <- start_position[1] + (length * cos(direction))
  new_y <- start_position[2] + (length * sin(direction))
  end_point <- c(new_x, new_y)
  
  segments(x0 = start_position[1], y0 = start_position[2],
           x1 = end_point[1], y1 = end_point[2], col = "black")
  return(end_point) # you should return your endpoint here.
}

# Question 25
elbow <- function(start_position, direction, length)  {
  end_point <- turtle(start_position, direction,length)
  turtle(end_point, direction - (pi/4), (0.95)*length)
}

# Question 26
spiral <- function(start_position, direction, length)  {
  end_point <- turtle(start_position, direction,length)
   if (length > 0.01){ #limit the length, so the function is not running forever. 
     #The smaller length parameter, the tighter the spiral is
  spiral(end_point, direction - (pi/4), (0.95) * length)
  }
  return("The function is calling itself (recursive) over and over again to create a sprial until the length is less than 0.01")
}

# Question 27
draw_spiral <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #create a plot
  
  plot(1, type = "n", xlim = c(0,10),
       ylim = c(0,10),
       xaxt = "n",
       yaxt = "n",
       xlab = "",
       ylab = "",
       main = "Drawing a spiral using fractal properties")
  
  spiral(c(5,5), pi*2, 2)
  
}

# Question 28
tree <- function(start_position, direction, length)  {
  end_point <- turtle(start_position, direction, length)
  
  if (length > 0.05) {
    tree(end_point, direction - (pi/4), (0.65) * length)
    tree(end_point, direction + (pi/4), (0.65) * length)
  }
}

draw_tree <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #create a plot
  plot(1, type = "n", xlim = c(0,10),
       ylim = c(0,10),
       xaxt = "n",
       yaxt = "n",
       xlab = "",
       ylab = "",
       main = "Drawing a tree using fractal properties")
  
  tree(c(4,4), pi/2, 2)
}

# Question 29
fern <- function(start_position, direction, length)  {
  end_point <- turtle(start_position, direction, length)
  if (length > 0.05) {
    fern(end_point, direction + (pi/4), (0.38) * length) #to the left
    fern(end_point, direction + (pi/4), (0.38) * length)
    fern(end_point, direction , (0.87) * length) #go straight
  }
}

draw_fern <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #create a plot
  plot(1, type = "n", xlim = c(0,20),
       ylim = c(0,20),
       xaxt = "n",
       yaxt = "n",
       xlab = "",
       ylab = "",
       main = "Drawing a half fern using fractal properties")
  
  fern(c(4,0), pi/2, 2)
}

# Question 30
fern2 <- function(start_position, direction, length, dir)  {
  end_point <- turtle(start_position, direction, length)
  if (length > 0.01){
  if (dir == 1) {
    fern2(end_point, direction + (pi/4), (0.38) * length, dir)
    fern2(end_point, direction , (0.87) * length,dir * (-1)) 
  } else {
    fern2(end_point, direction - (pi/4), (0.38) * length, dir)
    fern2(end_point, direction , (0.87) * length,dir * (-1)) 
  }
  }
}
draw_fern2 <- function()  {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  #create a plot
  plot(1, type = "n", xlim = c(-5,18),
       ylim = c(-5,18),
       xaxt = "n",
       yaxt = "n",
       xlab = "",
       ylab = "",
       main = "Drawing a beautiful fern using fractal properties")
  
  fern2(c(5,0), pi/2, 2, 1)
}

# Challenge questions - these are optional, substantially harder, and a maximum of 16% is available for doing them.  

# Challenge question A
Challenge_A <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  
  comm_max <- init_community_max(100)
  comm_min <- init_community_min(100)
  
  spec_rate <- 0.1
  
  stimulation <- 50
  
  #initialised the empty vectors
  spec_rich_max <- c()
  spec_rich_min <- c()
  
  
  for ( i in 1:stimulation) {
    
    max_rich <- neutral_time_series_speciation(comm_max,duration = 200, spec_rate)
    min_rich <- neutral_time_series_speciation(comm_min,duration = 200, spec_rate)
    
    spec_rich_max <- sum_vect(spec_rich_max, max_rich)
    spec_rich_min <- sum_vect(spec_rich_min, min_rich)
  }
  
  #find the avearage species richness over 50 times stimulation
  
  mean_spec_rich_max <- spec_rich_max/stimulation
  mean_spec_rich_min <- spec_rich_min/stimulation
  
  #find 97.2% confident interval species richness of each time point
  
  error_max <- qt(0.972, df=length(spec_rich_max)-1*sd(spec_rich_max)/sqrt(length(spec_rich_max)))
  error_min <- qt(0.972, df=length(spec_rich_min)-1*sd(spec_rich_min)/sqrt(length(spec_rich_min)))
  
  upper_max <- mean_spec_rich_max + error_max
  lower_max <- mean_spec_rich_max - error_max
  
  upper_min <- mean_spec_rich_min + error_min
  lower_min <- mean_spec_rich_min - error_min
  
  #create a generation vectors
  gen <- seq(1,201)
  
  #plot the species richness over generations 
  
  #initial maximum community
  plot(gen, mean_spec_rich_max,
       xlab = "Generations",
       ylab = "Species richness",
       pch = 1, cex = 0.5, 
       ylim = c(0, 100),
       col = "red",
       main = "Mean species richness over generations in two communities")
  
  #add the confident interval to the points
  arrows(gen,lower_max, gen, upper_max, 
         code = 3, angle = 90, length = 0.01,
         col = "red")
  
  #overlay the species richness over generations from the initial minimum community
  points(gen, mean_spec_rich_min, pch = 1, cex = 0.5, col = "blue")
  
  #add the confident interval to the points
  arrows(gen,lower_min, gen, upper_min,
         code = 3, angle = 90, length = 0.01,
         col = "blue")
  
  #estimate the burn-in generations visually
  
  segments(x0 = 43, y0 = 0, x1 = 43, y1=100)
  text(x = 64, y= 50, 
       label = "Burn-in generations is about 43")
  
  #add the figure legend
  legend(x = 120, y = 80, 
         legend = c("Initial maximum community", "Initial minimum community"),
         col = c("red", "blue"),
         box.lty = 0,
         lty = 1)
}

# Challenge question B
Challenge_B <- function() {
  # clear any existing graphs and plot your graph within the R window

}

# Challenge question C
Challenge_C <- function() {
  # clear any existing graphs and plot your graph within the R window
  graphics.off()
  #create a list of files to load
  files <- list.files(pattern = "^stimulation_.*\\.rda$")
  
  #initialised empty vectors
  
  richness_500 <- c()
  richness_1000 <- c()
  richness_2500 <- c()
  richness_5000 <- c()
  
  for (i in 1:100){
    load(files[i])
    
    #if population size is 500
    
    if (size == 500){
      
      #add the final species richness of each stimulation
      richness_500 <- sum_vect(richness_500, richness)
    } 
    
    #repeat the above for each population size
    if (size == 1000){
      richness_1000 <- sum_vect(richness_1000, richness)
    }
    
    if (size == 2500){
      richness_2500 <- sum_vect(richness_2500, richness)
    }
    
    if (size == 5000){
      richness_5000 <- sum_vect(richness_5000, richness)
    }
  }
  
  #find the avearage species richness in each population size
  
  mean_rich_500 <- richness_500/25
  mean_rich_1000 <- richness_1000/25
  mean_rich_2500 <- richness_2500/25
  mean_rich_5000 <- richness_5000/25
  
  #only plot the 1-4000 generations to accommodate the computer power
  
  mean_rich_500 <- mean_rich_500[1:4000]
  mean_rich_1000 <- mean_rich_1000[1:4000]
  mean_rich_2500 <- mean_rich_2500[1:4000]
  mean_rich_5000 <- mean_rich_5000[1:4000]
  
  #estimate the burn-in generations in the first 1000 generations chosen from visually inspection 
  
  burnin_500 <- which.min(diff(diff(mean_rich_500[1:1000])))
  burnin_1000 <- which.min(diff(diff(mean_rich_1000[1:1000])))
  burnin_2500 <- which.min(diff(diff(mean_rich_2500[1:1000])))
  burnin_5000 <- which.min(diff(diff(mean_rich_5000[1:1000])))
  
  par(mfrow = c(2,2))
  
  plot(mean_rich_500, pch = 19, cex = 0.1,
       xlab = "Generations",
       ylab = "Species richness",
       main = "A) Population size 500")
  segments(x0 = burnin_500, y0 = 0, x1 = burnin_500, y1 = 12)
  text(x = 1200, y = 6, 
       label = paste("Burn-in generation is about ", burnin_500,sep = ""))
  plot(mean_rich_1000, pch = 19, cex = 0.1,
       xlab = "Generations",
       ylab = "Species richness",
       main = "B) Population size 1000")
  segments(x0 = burnin_1000, y0 = 0, x1 = burnin_1000, y1 = 25)
  text(x = 1500, y = 11.5, 
       label = paste("Burn-in generation is about ", burnin_1000,sep = ""))
  plot(mean_rich_2500, pch = 19, cex = 0.1,
       xlab = "Generations",
       ylab = "Species richness",
       main = "C) Population size 2500")
  segments(x0 = burnin_2500, y0 = 0, x1 = burnin_2500, y1 = 55)
  text(x = 1700, y = 25, 
       label = paste("Burn-in generation is about ", burnin_2500,sep = ""))
  plot(mean_rich_5000, pch = 19, cex = 0.1,
       xlab = "Generations",
       ylab = "Species richness",
       main = "D) Population size 5000")
  segments(x0 = burnin_5000, y0 = 0, x1 = burnin_5000, y1 = 110)
  text(x = 1700, y = 50, 
       label = paste("Burn-in generation is about ", burnin_5000,sep = ""))
  
  mtext("Estimation of burn-in generation in each population size",  # Add main title
        side = 3,
        line = - 1,
        outer = TRUE)
  
  
}

# Challenge question D
Challenge_D <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question E
Challenge_E <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question F
Challenge_F <- function() {
  # clear any existing graphs and plot your graph within the R window
  
  return("type your written answer here")
}

# Challenge question G should be written in a separate file that has no dependencies on any functions here.


