# script:  6-4_model_selection
# purpose: running test for selecting SEM/SAR
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# define a generic function for calculating lagrange multiplier test on the results#######


# parameters: list with results, name of the output list, list of weights matrices
calculate.lm.statistics <- function (results_list = main_results_250,
                                     l_all_weights = weights_250) {

# create empty list for storing data

l_LM_all <- list()



# loop over list of weights matrices and variables and store results

for (i in 1:length(results_list)) {

  # create empty list  in list
  l_LM_all[[i]] <- list()
  
  # loop over the first three elements -  only OLS results
  for (j in 1:3) {
    
    # test for each vector

    l_LM_all[[i]][[j]] <- lm.LMtests(results_list[[i]][[j]],

                                     l_all_weights[[i]], zero.policy = TRUE, 
                                     test = c("all"))
    
  }
  
  # name elements

  names(l_LM_all[[i]]) <- names(results_list[[1]][1:3])

  
}


# assign names to main list
names(l_LM_all) <- names(results_list)


return(l_LM_all)


}






##########################################################################################


# run the function defined above on the main results
lagrange_250_st <- calculate.lm.statistics(results_list = main_results_250_st,
                                           l_all_weights = weights_250)




##################end of script###########################################################
##########################################################################################