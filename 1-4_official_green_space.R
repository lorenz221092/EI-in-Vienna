# script:  1-4_official_green_space
# purpose: loading official green space data
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# import public green data vom shapefile
# https://www.data.gv.at/katalog/dataset/stadt-wien_ffentlichzugngigegrnflchenwien
shp_greenspace <- readOGR(paste0(wd_conf_data, "/OEFFGRUENFLOGD/", 
                          "OEFFGRUENFLOGDPolygon.shp"))


# change crs of socioeconomic data data to crs of base data
shp_greenspace <- spTransform(shp_greenspace, CRSobj= CRS_base[[2]])


# remove intersecting green spaces
shp_greenspace <- gUnionCascaded(shp_greenspace)


# applying 0 buffer to tackle self intersection problems, see description:
# https://gis.stackexchange.com/questions/163445/getting-topologyexception-
# input-geom-1-is-invalid-which-is-due-to-self-intersec)

shp_greenspace <- gSimplify(shp_greenspace, tol = 0.00001)
shp_greenspace <- gBuffer(shp_greenspace, byid=TRUE, width=0)

shp_base_buffer0 <- gSimplify(shp_base, tol = 0.00001)
shp_base_buffer0 <- gBuffer(shp_base, byid=TRUE, width=0)


# calculate intersection areas with buffer ###############################################


# compute the intersection area of the green spaces and the buffer of the census cell
shp_greenspace_intersection0 <- intersect(shp_base_buffer0, shp_greenspace)


# get the area of intersections and attach them to data frame
shp_greenspace_intersection0$`Intersection-Area` <- sapply(slot(
  shp_greenspace_intersection0, "polygons"), slot, "area")


# extract dataframe to make aggregation easier
df_greenspace_intersection0  <- shp_greenspace_intersection0@data
df_greenspace_intersection0  <- df_greenspace_intersection0[,c("ID", "Intersection-Area")]


# calculate percentage of green space in buffer and
# set maximum value because of self-intersection artifact
df_greenspace_intersection0$`Perc-Green-Space0` <- 
  df_greenspace_intersection0$`Intersection-Area`/
  max(df_greenspace_intersection0$`Intersection-Area`) * 100 


# rename variables
names(df_greenspace_intersection0) <- c("ID", "Intersection_Area", "Perc_UGS")


# remove variable
df_greenspace_intersection0 <- df_greenspace_intersection0[,-2]




# purge environment
rm(shp_base_buffer0, shp_greenspace_intersection0)
##################end of script###########################################################
##########################################################################################