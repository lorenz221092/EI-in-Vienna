# script:  6-1_run_main_regressions
# purpose: running main regression models
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################



main_results_250_st <- run.my.regres.function(
  specification="NDVI ~ Perc_Not_AUT_Orig",
  shp = shp, weights = weights_250, standardize = TRUE)






##################end of script###########################################################
##########################################################################################