# script:  2-0_merge_data
# purpose: merge data 
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# merge socioeconomic and base data
shp <- merge(shp_base, shp_socioecon)


# then merge with ndvi data
shp <- merge(shp, shp_ndvi_intersection)


# then merge district dummies with rest of data
shp <- merge(shp, df_dummies)


# store the names of the dummies in a vector
ch_dummies <- names(df_dummies[,-1])


# merge with official UGS data
shp <- merge(shp, df_greenspace_intersection0)


# if Per-Green-Space is NA it actually means no green space: substitute with 0s
shp$`Perc_UGS`[is.na(shp$`Perc_UGS`)] <- 0


# purge NA rows
shp <- sp.na.omit(shp, margin = 1)


# has to have same length as original socioecon file
nrow(shp_socioecon) == nrow(shp)


# remove Name
shp <- shp[,-2]


##################end of script###########################################################
##########################################################################################