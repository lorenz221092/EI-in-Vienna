# script:  1-3_stack_NDVI
# purpose: stacking NDVI and calculating averages over 250 grid
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################
 



# create list of NDVI file paths
all_ndvi_files <- list.files(paste0(wd_conf_data, "/sentinel/NDVI"),
                             full.names = TRUE,
                             pattern = ".tif$")


# create a time series raster stack
all_ndvi_stack <- stack(all_ndvi_files)


# apply scale factor
all_ndvi_stack <- all_ndvi_stack/10000


# set all negative pixels to zero
all_ndvi_stack <- reclassify(all_ndvi_stack, cbind(-Inf, 0, 0), right = FALSE)


# calculate mean ndvi
all_ndvi_mean <- raster:: calc(all_ndvi_stack, mean, na.rm = TRUE)




# extract the mean ndvi per census cell###################################################

# adapt crs
shp_base_tr <- spTransform(shp_base, CRSobj= crs(all_ndvi_mean))


# calculate the mean
shp_ndvi_intersection <-raster::extract(all_ndvi_mean, shp_base_tr, fun = mean, sp = TRUE, 
                                        method = "simple", na.rm = TRUE)

# remove rest of the data
shp_ndvi_intersection  <- shp_ndvi_intersection[, c("ID", "layer")]


# rename variables
names(shp_ndvi_intersection) <- c("ID", "NDVI")


# transform NDVI
shp_ndvi_intersection$`NDVI` <- shp_ndvi_intersection$`NDVI` * 100


# change to standard crs
shp_ndvi_intersection <- spTransform(shp_ndvi_intersection, CRSobj=CRS_base[[2]])


# purge environment
rm(shp_base_tr, all_ndvi_files, all_ndvi_mean, all_ndvi_stack)
##################end of script###########################################################
##########################################################################################


