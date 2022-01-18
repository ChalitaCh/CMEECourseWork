len <- c(20000)

data_b <- read.csv("bent-toed_gecko.csv", stringsAsFactors=F, header=F, colClasses=rep("character", len))
dim(data_b)
data_L<- read.csv("leopard_gecko.csv", stringsAsFactors=F, header=F, colClasses=rep("character", len))
data_W <- read.csv("western_banded_gecko.csv", stringsAsFactors=F, header=F, colClasses=rep("character", len))

#Calculate the divergence between B and L

site_total <- 0
site_divergence <- 0

divrate_BL <- site_divergence/site_total

#site_divergence 
#1. fixed within both species
#2. different between the species
#site_total
#1. fixed within the species 


fixed_sites_within_species <- c()
divergence_and_fixed_species <- c()

for (i in 1:ncol(data_b)) {
  if (length(unique(data_b[,i])) == 1 & length(unique(data_L[,i])) == 1 ){ #Condition 1
    fixed_sites_within_species <- c(fixed_sites_within_species,i)
    if (unique(data_b[,i]) != unique(data_L[,i])){ #Condition 2
      divergence_and_fixed_species <- c(divergence_and_fixed_species,i) #Condition 1 and 2
    }
  }
}

divrate_BL <- length(divergence_and_fixed_species)/length(fixed_sites_within_species)

cat("divergence between Bent toed gecko and Leopard gecko is", round(divrate_BL, digits = 10), "per site per year")

#Calculate the divergence between W and L

fixed_sites_within_species <- c()

divergence_and_fixed_species <- c()

for (i in 1:ncol(data_W)) {
  if (length(unique(data_W[,i])) == 1 & length(unique(data_L[,i])) == 1){
    fixed_sites_within_species <- c(fixed_sites_within_species,i)
    if (unique(data_W[,i]) != unique(data_L[,i])){
    divergence_and_fixed_species <- c(divergence_and_fixed_species,i)
    }
  }
}

divrate_WL <- length(divergence_and_fixed_species)/length(fixed_sites_within_species)

#Calculate the divergence between W and B

fixed_sites_within_species <- c()

divergence_and_fixed_species <- c()

for (i in 1:ncol(data_W)) {
  if (length(unique(data_W[,i])) == 1 & length(unique(data_b[,i])) == 1){
    fixed_sites_within_species <- c(fixed_sites_within_species,i)
    if (unique(data_W[,i]) != unique(data_b[,i])){
      divergence_and_fixed_species <- c(divergence_and_fixed_species,i)
    }
  }
}

divrate_Wb <- length(divergence_and_fixed_species)/length(fixed_sites_within_species)

## from these divergence rates we can infer that W and B are close species while L is the outgroup

## estimate mutation rate per site per year
mut_rate <- divrate_BL / (2 * 3e7)


## estimate divergence time
div_time <- divrate_Wb / (2 * mut_rate)

cat("\nThe two species have a divergence time of", formatC(div_time, format = "e", digits = 3), "years.")
cat("\nThe most likely species tree is L:(W:B).")



