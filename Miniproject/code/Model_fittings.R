rm(list = ls())
#Setting work directory

setwd("CMEECourseWork/Miniproject/code/")

#load the required package

require(minpack.lm)
source("Model_functions.R")

#load the dataset

data <- read.csv("../data/GrowthDataClean.csv")

#convert the Population to the logarithm

data$logPopBio <- log10(data$PopBio)

#find the length of unique ID group in the dataset

n <- length(unique(data$ID))

#Pre-allocated the data-frame to store the starting values and optimised parameters for model fittings

InitialValue <- data.frame(ID = rep(NA,n), 
                         N0 = rep(NA,n),
                         K = rep(NA,n),
                         rmax = rep(NA,n),
                         t_lag = rep(NA,n))


fit_paras <- data.frame(ID = rep(NA,n),
                           GomAIC = rep(NA, n),
                          GomBIC = rep(NA, n),
                           GomRmax = rep(NA,n),
                           GomK = rep(NA, n),
                           GomN0 = rep(NA, n),
                           Gomt_lag = rep(NA, n),
                           LogAIC = rep(NA, n),
                        LogBIC = rep(NA, n),
                           LogRmax = rep(NA,n),
                           LogK = rep(NA,n),
                           LogN0 = rep(NA,n),
                           Qua_AIC = rep(NA, n),
                        Qua_BIC = rep(NA, n),
                           Qua_intercept = rep(NA,n),
                           Qua_a = rep(NA,n),
                           Qua_b = rep(NA,n),
                           Cubic_AIC = rep(NA,n),
                        Cubic_BIC = rep(NA, n),
                           Cubic_intercept = rep(NA,n),
                           Cubic_a = rep(NA, n),
                           Cubic_b = rep(NA, n),
                           Cubic_c = rep(NA, n))


set.seed(1234) #set seed to ensure the same number every run

#generate the initial starting values

for (i in 1:n){
  #Create a subset data for each unique ID
  subsetdata <- subset(data, data$ID == i)
  
  InitialValue[i,1] <- i #sorting the ID number
  
  InitialValue[i,2] <- min(subsetdata$logPopBio) #N0 - Initial population size
  
  InitialValue[i,3] <- max(subsetdata$logPopBio) #K - Carrying population capacity
  
  t <- which.max(diff(subsetdata$logPopBio)) #Finding the index where different in population is highest
  
  InitialValue[i,4] <- max(diff(subsetdata$logPopBio))/(subsetdata[t+1, "Time"] - subsetdata[t, "Time"]) #Rmax - the rate at which growth rate is maximum 
  
  InitialValue[i,5] <- subsetdata$Time[which.max(diff(diff(subsetdata$logPopBio)))] # t_lag - last timepoint of lag phase
  
}



for (i in 1:n){
  #Create a subset data for each unique ID
  subsetdata <- subset(data, data$ID == i)
  
  #Sampling the starting values using the normal distribution
  N0 <- rnorm(100, mean = InitialValue$N0[1], sd = 2)
  K <- rnorm(100, mean = InitialValue$K[1], sd = 2)
  rmax <- rnorm(100, mean = InitialValue$rmax[1], sd = 2)
  t_lag <- rnorm(100, mean = InitialValue$t_lag[1], sd = 2)
  
  #Pre-allocate the dataframes to store the AIC value and the parameters of the model in each iteration
  
  gom_stats <- data.frame(AIC = rep(NA,100),
                          BIC = rep(NA, 100),
                          rmax = rep(NA,100),
                          K = rep(NA,100),
                          N0 = rep(NA,100),
                          t_lag = rep(NA,100))
  
  log_stats <- data.frame(AIC = rep(NA, 100),
                          BIC = rep(NA ,100),
                          rmax = rep(NA, 100),
                          K = rep(NA, 100),
                          N0 = rep(NA, 100))
  
 ################################# Model fitting ###############################
  
  for (j in 1:100){
  #Non-Linear Least-square models
  #Gompertz model  
  
  tryCatch( #Allow errors to happen without stopping the loops
    {
      
      #Fit the model using nlsLM function
      fit_gom <- nlsLM(logPopBio ~ gompertz(t = Time, rmax, K, N0, t_lag), subsetdata,
                   start = list(rmax = rmax[j],
                                K = K[j],
                                N0 = N0[j],
                                t_lag = t_lag[j]),
                   control = nls.lm.control(maxiter = 300))
      
      #When successful, store the AIC values and parameters coefficient into the
      #pre-allocated dataframe
      gom_stats[j,] <- c(AIC(fit_gom),
                         BIC(fit_gom),
                         coef(fit_gom)["rmax"],
                         coef(fit_gom)["K"],
                         coef(fit_gom)["N0"],
                         coef(fit_gom)["t_lag"])
      
      #If there is an error
    }, error = function(e){
      
      #Store the NA instead to the pre-allocated dataframe
      gom_stats[j,] <- c(rep(NA, 6))
      
    },#not showing the error messages
    slient = TRUE)
    
  #Find the best permutation with lowest AIC 
  gom_best <- subset(gom_stats, gom_stats$AIC == min(gom_stats$AIC, na.rm = TRUE))

  
  #Logistic model
  
  
  tryCatch(#Same as described above
    {
      
      fit_logis <- nlsLM(logPopBio ~ logistic(t = Time, rmax, K ,N0), subsetdata,
                         start = list(rmax = rmax[j],
                                      N0 = N0[j],
                                      K = K[j]),
                         control = nls.lm.control(maxiter = 300))
      
      log_stats[j,] <- c(AIC(fit_logis),
                         BIC(fit_logis),
                         coef(fit_logis)["rmax"],
                         coef(fit_logis)["K"],
                         coef(fit_logis)["N0"])
      },error = function(e){
        
        log_stats[j,] <- c(rep(NA,5))
      },
    silent = TRUE)

  log_best <- subset(log_stats, log_stats$AIC == min(log_stats$AIC, na.rm = TRUE))
  
  }

  #Linear regression models
  
  #Quadratic polynomial model
  tryCatch(
    {
      fit_qua <- lm(logPopBio ~ I(Time) + I(Time^2), subsetdata)
    },
    error = function(e){},
    silent = TRUE)
  
  #Cubic polynomial model

  tryCatch(
    {
      fit_cubic <- lm(logPopBio ~ I(Time) + I(Time^2) + I(Time^3), subsetdata)
    },
    error = function(e){},
    silent = TRUE)
  
  #Store all the stats and optimised parameters of each model into Fit_paras dataframe
  #Note that only the first set of parameters from best models (i.e. with minimum AIC)
  #is chosen as the estimated parameters are roughly the same.
  
  fit_paras[i,] <- c(i,
                        gom_best$AIC[1],
                     gom_best$BIC[1],
                        gom_best$rmax[1],
                        gom_best$K[1],
                        gom_best$N0[1],
                        gom_best$t_lag[1],
                        log_best$AIC[1],
                     log_best$BIC[1],
                        log_best$rmax[1],
                        log_best$K[1],
                        log_best$N0[1],
                        AIC(fit_qua),
                     BIC(fit_qua),
                        coef(fit_qua)[1],
                        coef(fit_qua)[2],
                        coef(fit_qua)[3],
                        AIC(fit_cubic),
                     BIC(fit_cubic),
                        coef(fit_cubic)[1],
                        coef(fit_cubic)[2],
                        coef(fit_cubic)[3],
                        coef(fit_cubic)[4])
}

#Save the result to a csv named Fitted_parameters.csv

write.csv(fit_paras, "../results/Fitted_parameters.csv", row.names = FALSE)
