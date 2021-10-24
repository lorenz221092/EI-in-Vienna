# script:  2-2_maup_aggregate
# purpose: aggregate 250 raster to districts and 500x500m and 1x1km 
#          to test for robustness against scaling
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# 500m grid 
# https://www.data.gv.at/katalog/dataset/stat_regionalstatistische-rastereinheiten66c96
shp_base_500     <- readOGR(paste0(wd_conf_data,
                                  "/STATISTIK_AUSTRIA_L000500_LAEA", 
                                  "/STATISTIK_AUSTRIA_L000500_LAEA.shp"))

# 1000m grid
# https://www.data.gv.at/katalog/dataset/stat_regionalstatistische-rastereinheiten66c96
shp_base_1000    <- readOGR(paste0(wd_conf_data,
                                  "/STATISTIK_AUSTRIA_L001000_LAEA", 
                                  "/STATISTIK_AUSTRIA_L001000_LAEA.shp"))

# change crs
shp_base_500  <- spTransform(shp_base_500,  CRSobj= CRS_base[[2]])
shp_base_1000 <- spTransform(shp_base_1000, CRSobj= CRS_base[[2]])


# collapse shp to spatial points to avoid intersection issues
shp_points <- SpatialPointsDataFrame(coordinates(shp), data = shp@data, 
                                     proj4string=CRS(proj4string(shp)))

# population base for income and other variables differ slightly --> create inc_population
shp_points$Income_Population <- shp_points$Tot_Income / shp_points$Avg_Income

# select the relevant variables
shp_points <- shp_points[,c("NDVI", "Not_AUT_Origin", "Population",
                            "Seniors", "Tot_Income", "Income_Population", 
                            "Not_AUT_GER_Origin", "Not_EU_Citizen",
                            "Distr_01", "Distr_02", "Distr_03", "Distr_04", "Distr_05",
                            "Distr_06", "Distr_07", "Distr_08", "Distr_09", "Distr_10",
                            "Distr_11", "Distr_12", "Distr_13", "Distr_14", "Distr_15",
                            "Distr_16", "Distr_17", "Distr_18", "Distr_19", "Distr_20",
                            "Distr_21", "Distr_22", "Distr_23")]


# remove data
shp_base_500_nodata <- SpatialPolygons(Srl = shp_base_500@polygons, 
                                      proj4string = shp_base_500@proj4string, 
                                      pO = shp_base_500@plotOrder)

# remove data
shp_base_1000_nodata <- SpatialPolygons(Srl = shp_base_1000@polygons, 
                                      proj4string = shp_base_1000@proj4string, 
                                      pO = shp_base_1000@plotOrder)


# extract the mean values
df_500   <-  sp::over(shp_base_500_nodata,  shp_points, fn=mean)
df_1000  <-  sp::over(shp_base_1000_nodata, shp_points, fn=mean)



# generate new variables 

# 500
df_500$Perc_Not_AUT_Orig  <- df_500$Not_AUT_Orig       * 100 / df_500$Population
df_500$Perc_Seniors       <- df_500$Seniors            * 100 / df_500$Population
df_500$Avg_Income         <- df_500$Tot_Income           / df_500$Income_Population
df_500[,7:29]             <- round(df_500[,7:29]+0.1, 0)


# 1000
df_1000$Perc_Not_AUT_Orig  <- df_1000$Not_AUT_Orig        * 100 / df_1000$Population
df_1000$Perc_Seniors       <- df_1000$Seniors             * 100 / df_1000$Population
df_1000$Avg_Income         <- df_1000$Tot_Income           / df_1000$Income_Population



# merge the dataframe with the polygons
shp_500  <-  sp::merge(shp_base_500, df_500, by = "row.names")
shp_1000 <-  sp::merge(shp_base_1000, df_1000, by = "row.names")


# drop NAs
shp_500  <-  sp.na.omit(shp_500, margin = 1)
shp_1000 <-  sp.na.omit(shp_1000, margin = 1)





# for districts###########################################################################


# remove data
shp_boundaries_nodata <- SpatialPolygons(Srl = shp_boundaries@polygons, 
                                         proj4string =shp_boundaries@proj4string, 
                                         pO = shp_boundaries@plotOrder)

# extract the mean values
df_distr <- sp::over(shp_boundaries_nodata, shp_points, fn=mean)


# generate new variables 
df_distr$Perc_Not_AUT_Orig  <- df_distr$Not_AUT_Orig       * 100 / df_distr$Population
df_distr$Perc_Seniors       <- df_distr$Seniors            * 100 / df_distr$Population
df_distr$Avg_Income         <- df_distr$Tot_Income           / df_distr$Income_Population


# merge the dataframe with the polygons
shp_distr  <-  sp::merge(shp_boundaries, df_distr, by = "row.names")



# purge environment
rm(df_500, df_1000, df_distr, shp_boundaries_nodata, shp_base_500_nodata, 
   shp_base_1000_nodata, shp_points)
##################end of script###########################################################
##########################################################################################