# script:  6-0_my_regression_function
# purpose: specifying regression function 
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# defina a generic function for standardizing variables for further use below ############
scale.vars <- function(x, na.rm = FALSE) (x - mean(x, na.rm = na.rm)) / sd(x, na.rm)





# define a generic function for all regressions###########################################

my.regres.functions <-function(specification = specification,
                          shp = shp, weights = weights, omit.FE = FALSE) {

  # empty list for storing the results
  all_results <- list()
  
  
  # definte the model specifications
  str0 <- specification
  str1 <- "+ Population + Perc_Seniors + Avg_Income"
  
  
  # define dummy string according to subset of  cencus cells
  if ("Distr" %in% names(shp)) {
  
  str2 <- "+ Distr_02 +  Distr_03 +  Distr_04 +
             Distr_05 +  Distr_06 +  Distr_07 +
             Distr_08 +  Distr_09 +  Distr_10 +
             Distr_11 +  Distr_12 +  Distr_13 +
             Distr_14 +  Distr_15 +  Distr_16 +
             Distr_17 +  Distr_18 +  Distr_19 +
             Distr_20 +  Distr_21 +  Distr_22 +
             Distr_23"
  } else {
    
    str2 <- "+ Distr_02 +  Distr_03 +  Distr_04 +
             Distr_05 +  Distr_06 +  Distr_07 +
             Distr_08 +  Distr_09 +  Distr_10 +
             Distr_11 +  Distr_12 +  Distr_13 +
             Distr_14 +  Distr_15 +  Distr_16 +
             Distr_17 +  Distr_18 +  Distr_19 +
             Distr_20 +  Distr_23"
    
  }
  
  
  
  # plug them together to formula objects
  model0 <- as.formula(str0)
  model1 <- as.formula(paste0(str0,str1))
  model2 <- as.formula(paste0(str0,str1,str2))
  
  #ols models
  all_results[[1]] <- lm(model0, shp)
  all_results[[2]] <- lm(model1, shp)
  if (omit.FE == FALSE) {
    all_results[[3]] <- lm(model2, shp) } else {
      all_results[[3]] <- NULL
    }
  
  #sar models
  all_results[[4]] <- lagsarlm(model0, data = shp, weights, zero.policy = T)
  all_results[[5]] <- lagsarlm(model1, data = shp, weights, zero.policy = T)
  if (omit.FE == FALSE) {
  all_results[[6]] <- lagsarlm(model2, data = shp, weights, zero.policy = T) } else {
    all_results[[6]] <- NULL
  }
  
  
  
  #sem models
  all_results[[7]] <- errorsarlm(model0, data = shp, weights, zero.policy = T)
  all_results[[8]] <- errorsarlm(model1, data = shp, weights, zero.policy = T)
  if (omit.FE == FALSE) {
  all_results[[9]] <- errorsarlm(model2, data = shp, weights, zero.policy = T) } else {
    all_results[[9]] <- NULL
  }
  
  return(all_results)

}


##########################################################################################






# define a generic function for running the function above on data and a list of weights##


run.my.regres.function<-function(specification="NDVI ~ Perc_Not_AUT_Orig",
                                 shp = shp, weights = weights_250, 
                                 standardize = FALSE, omit.FE = FALSE){
  
  
  # standardize relevant variables with function defined above if parameter set to TRUE
  if (standardize == TRUE ) {shp@data<-shp@data %>% mutate_at(relevant_vars, scale.vars) }
  
  
  # empty list for storing the results
  l_results <- list()
  
  
  # loop over the weights list
  for (i in 1:length(weights)) {
    
    l_results[[i]] <- my.regres.functions(specification = specification, shp = shp, 
                                          weights = weights[[i]])
    
  }
  
  
  # assign names to the stored data
  names(l_results) <- names(weights)
  
  # loop over the sublist and assign names
  for (i in 1:length(l_results)) {
    

    names(l_results[[i]]) <- c("OLS0", "OLS1", "OLS2",
                               "SAR0", "SAR1", "SAR2",
                               "SEM0", "SEM1", "SEM2" )
    
  }
  
  # return the list containing the sublist
  return(l_results)
  
}






##################end of script###########################################################
##########################################################################################