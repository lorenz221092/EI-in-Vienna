# script:  6-2_residual_testing
# purpose: testing OLS residuals for standard properties
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# define a generic function for quick inspection of residuals#############################

inspect.residuals <- function(shp = shp, results_list = main_results_250,
                              weights = "W", model = "SAR2", 
                              indep = c("Perc_Not_AUT_Orig"),
                              dep = c("NDVI"), standardize = FALSE) {
        
        
        # standardize relevant variables with function defined above if parameter set to T
        if (standardize == TRUE ) {shp@data <- shp@data %>% mutate_at(relevant_vars, 
                                                                      scale.vars) }
        
        # x vs y
        plot(shp[[indep]],
             shp[[dep]],
             main = "X vs Y", xlab = "X", ylab = "Y")
        abline(a = 0, b = cor(shp[[indep]], shp[[dep]]), col = "red")
        
        # res vs x
        plot(shp[[indep]],
             results_list[[weights]][[model]]$residuals, 
             main = "Residuals vs X", xlab = "X", ylab = "Residuals")
        abline(a = 0, b = 0, col = "red")
        
        # res vs x
        plot(shp[[dep]],
             results_list[[weights]][[model]]$residuals,
             main = "Residuals vs Y",  
             xlab = "Y", ylab = "Residuals")
        abline(a = 0, b = 0, col = "red")
        
        # res vs fit
        plot(results_list[[weights]][[model]]$fitted.values, 
             results_list[[weights]][[model]]$residuals,
             main = "Residuals vs Fitted Values",  
             xlab = "Fitted Values", ylab = "Residuals")
        abline(a = 0, b = 0, col = "red")
        
        # stand res vs fit
        plot(results_list[[weights]][[model]]$fitted.values, 
             scale.vars(results_list[[weights]][[model]]$residuals),
             main = "Standardized Residuals vs Fitted Values",  
             xlab = "Fitted Values", ylab = "Standardized Residuals")
        abline(a = 0, b = 0, col = "red")
        
        # fit vs y
        plot(results_list[[weights]][[model]]$fitted.values, 
             shp[[dep]],
             main = "Y vs Fitted Values",  
             xlab = "Fitted Values", ylab = "Y")
        abline(a = 0, b = 1, col = "red")
        

    
        # qqplot
        qqnorm(results_list[[weights]][[model]]$residuals) 
        qqline(results_list[[weights]][[model]]$residuals, col = "red")   
        
        
        # hist
        hist(results_list[[weights]][[model]]$residuals, breaks = 31, 
             main = "Residuals", xlab =" ")


}




##################end of script###########################################################
##########################################################################################