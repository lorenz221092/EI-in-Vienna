# script:  4-0_spatial_descriptive_statistics
# purpose: summarizing data including spatial relations
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# define the relevant variables for statistics
relevant_vars <- c("NDVI",
                   "Perc_Not_AUT_Orig",
                   "Population", "Perc_Seniors", "Avg_Income", "Perc_UGS")







# moran test for all used variables with all weights: under randomization#################


# create empty list for storing data
moran_random <- list()


# loop over list of weights matrices and variables and store results
for (i in 1:length(weights_250)) {
  
  # create empty list  in list
  moran_random[[i]] <- list()
  
  # loop over variables
  for (j in 1:length(relevant_vars)) {
    
    # moran test for each vector
    moran_random[[i]][[j]] <- moran.test(shp@data[,relevant_vars[j] ],
                                           weights_250[[i]],
                                           randomisation = TRUE,
                                           zero.policy = TRUE)
  }
  
  # name elements
  names(moran_random[[i]]) <- relevant_vars
  
}


# assign names to main list
names(moran_random) <- names(weights_250)





##################end of script###########################################################
##########################################################################################