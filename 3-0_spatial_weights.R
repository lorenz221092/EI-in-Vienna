# script:  3-0_spatial_weights
# purpose: generate different spatial weights matrices
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# define a generic function for calculating weights matrices from shapefiles##############


calculate.weights.matrices <- function(shp = shp) {



# create an empty list to store the weights
l_all_weights <- list()



# queen contiguity #######################################################################

# extract neighbour list from shp data
W_list                  <- poly2nb(shp, queen = TRUE)


# generate spatial weights: first order queen contiguity 
l_all_weights[[1]]      <-   W    <- nb2listw(W_list, style = "W", zero.policy = TRUE)


# generate spatial weights: second order queen contiguity 
WW_list   <- nblag(W_list, maxlag = 2)
WW_cumul  <- nblag_cumul(WW_list)
l_all_weights[[2]]      <-   WW   <- nb2listw(WW_cumul, style = "W", zero.policy = TRUE)



# KNN ####################################################################################

# extract neighbour list from shp and create matrix for knn8 and knn24
KNN8_list <- knn2nb(knearneigh(coordinates(shp), k = 8 ))
l_all_weights[[3]]      <-   KNN8  <- nb2listw(KNN8_list)

KNN24_list <- knn2nb(knearneigh(coordinates(shp), k = 24 ))
l_all_weights[[4]]      <-   KNN24 <- nb2listw(KNN24_list)



# distance based #########################################################################


# all possible neighours 
distw2 <- dnearneigh(coordinates(shp), 0, 2000) # 2000m distance band

# (raw) distances
dnbdists2 <- nbdists(distw2, coordinates(shp))

# calculate inverse distances and store in neighourhood list
gl2 <- lapply(dnbdists2, function(x) 1/x)

# Create neighbourhood lists and store as list elements
l_all_weights[[5]] <- nb2listw(distw2, glist=gl2, zero.policy=FALSE)




# name elements of the list ##############################################################
names(l_all_weights) <- c("W", "WW", "KNN8", "KNN24", "ID2")


return(l_all_weights)


}



##########################################################################################
# run the function defined above on the shapefiles

# for the main file
weights_250 <- calculate.weights.matrices(shp = shp)

# for the 500m robustness check
weights_500 <- calculate.weights.matrices(shp = shp_500)

# for the 1000m robustness check
weights_1000 <- calculate.weights.matrices(shp = shp_1000)

# for districts
weights_distr <- list()
weights_distr[[1]] <- nb2listw(poly2nb(shp_distr, queen = TRUE),
                               style = "W", zero.policy = TRUE)
names(weights_distr) <- c("W")


##################end of script###########################################################
##########################################################################################