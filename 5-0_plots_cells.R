# script:  5-0_plots_cells
# purpose: plotting ndvi and foreigners
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# load example rgb with no cloud cover
rgb  <- stack(paste0(wd_conf_data, 
                     "/sentinel/RGB432B/S2B2A_20200828_122_Vienna_RGB432B_10.tif"))

# change crs
rgb_tr <- projectRaster(from = rgb, crs = proj4string(shp_base))




# ndvi
tm_shape(rgb_tr)+
  tm_rgb(alpha = 0.8) +
tm_shape(shp) +
  tm_fill(col="NDVI", title = "Re-scaled NDVI",
          style = "cont", palette = viridis(20)) +
  tm_borders(col = "black", lwd = 0.4, alpha = 0) +
  tm_shape(shp_boundaries) +
  tm_borders(lwd=1.2, col = "red") +
  tm_compass(type = "arrow", position = c("RIGHT", "TOP")) +
  tm_scale_bar() +
  tm_grid(lines = FALSE, labels.size = 0.5, labels.r = c(0,90)) +
  tm_credits("ETRS89", position = c("LEFT", "BOTTOM"))



# foreigners
tm_shape(rgb_tr)+
  tm_rgb(alpha = 0.8) +
tm_shape(shp) +
  tm_fill(col="Perc_Not_AUT_Orig", title = "Percentage of Foreigners",
          style = "cont", palette = viridis(20)) +
  tm_borders(col = "black", lwd = 0.4, alpha = 0) +
  tm_shape(shp_boundaries) +
  tm_borders(lwd=1.2, col = "red") +
  tm_compass(type = "arrow", position = c("RIGHT", "TOP")) +
  tm_scale_bar() +
  tm_grid(lines = FALSE, labels.size = 0.5, labels.r = c(0,90)) +
  tm_credits("ETRS89", position = c("LEFT", "BOTTOM"))







##################end of script###########################################################
##########################################################################################