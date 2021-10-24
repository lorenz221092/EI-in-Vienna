# script:  1-0_data_grid_base
# purpose: load base statistik austria raster grid 250x250m
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# load 250x250 grid from
# https://www.data.gv.at/katalog/dataset/stat_regionalstatistische-rastereinheiten66c96
shp_base <- readOGR(dsn=paste0(wd_conf_data, 
                               "/STATISTIK_AUSTRIA_L000250_LAEA_W"),
                    stringsAsFactors = FALSE,
                    layer="STATISTIK_AUSTRIA_L000250_LAEA_W")

# get coordinate reference system from Statistik Austria
CRS_base      <- st_crs(shp_base)

# add a short unique identifier to each cell for manual removal of islands later
shp_base$IDshort <- c(0:(nrow(shp_base)-1))

# count the cells
n_cells_0        <- nrow(shp_base)


# load district boundary data from
# https://www.data.gv.at/katalog/dataset/stadt-wien_bezirksgrenzenwien
shp_boundaries <- readOGR(paste0(wd_conf_data, 
                                 "/BEZIRKSGRENZEOGD/BEZIRKSGRENZEOGDPolygon.shp"))


# change crs of boundary data data to crs of base data
shp_boundaries <- spTransform(shp_boundaries, CRSobj= CRS_base[[2]])


##################end of script###########################################################
##########################################################################################



