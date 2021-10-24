# script:  6-5_extract_sar_impacts
# purpose: calculating direct and incirect effects of the SAR models
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# define a generic function for calculating the sar impacts###############################


# parameters: list with SAR results, name of the output list, list of weights matrices
calculate.impacts <- function (results_list =  main_results_250,
                               l_all_weights = weights_250) {

# create empty list for storing data
l_sar_impacts <- list()


# loop over list of weights matrices and variables and store results
for (i in 1:length(results_list)) {
  
  # create empty list  in list
  l_sar_impacts[[i]] <- list()
  
  
  # loop over the 4th to the 6th element (SAR results only)
  for (j in 4:6) {
    
    
    # Calculate the impacts:
    # Save space by dropping 0s in the weights matrix,
    # Generate powers of traces using Neumann series
    # 1000 repetitions
    l_sar_impacts[[i]][[j-3]] <- impacts(results_list[[i]][[j]], 
                                       tr = trW(as(as_dgRMatrix_listw(
                                         l_all_weights[[i]]), "CsparseMatrix"), 
                                         type="mult"),
                                       R=1000, zstats = TRUE)
    
  }
  
  # name the sublist elements
  names(l_sar_impacts[[i]]) <- names(results_list[[1]][4:6])
  
}


# assign names to main list
names(l_sar_impacts) <- names(results_list)


return(l_sar_impacts)


}





##################end of script###########################################################
##########################################################################################