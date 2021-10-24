# script:  0-1_functions
# purpose: user defined functions
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# define the sp.na.omit fuction from spatialEco package ##################################
# https://www.rdocumentation.org/packages/spatialEco/versions/1.3-1/topics/sp.na.omit
# credits to  Jeffrey S Evans

sp.na.omit <- function (x, col.name = NULL, margin = 1) 
{
  if (!inherits(x, "SpatialPointsDataFrame") & !inherits(x, 
                                                         "SpatialPolygonsDataFrame") & 
      !inherits(x, "SpatialLinesDataFrame")) 
    stop("MUST BE sp SpatialPointsDataFrame OR SpatialPolygonsDataFrame class object")
  if (!is.null(col.name)) {
    if (is.na(match(col.name, names(x)))) 
      stop(col.name, "does not exist in data")
    return(x[-which(is.na(x@data[, col.name])), ])
  }
  else {
    na.index <- unique(as.data.frame(which(is.na(x@data), 
                                           arr.ind = TRUE))[, margin])
    if (margin == 1) {
      cat("Deleting rows: ", na.index, "\n")
      return(x[-na.index, ])
    }
    if (margin == 2) {
      cat("Deleting columns: ", na.index, "\n")
      return(x[, -na.index])
    }
  }
}




##################end of script###########################################################
##########################################################################################