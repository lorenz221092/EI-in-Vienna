# script:  5-1_plot_rgb
# purpose: plotting rgb for overview
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# districts, streets, green spaces########################################################

# load greenspace data
shp_greenspaces <- readOGR(paste0(wd_conf_data,
                                  "/OEFFGRUENFLOGD/OEFFGRUENFLOGDPolygon.shp"))

# load street data 
# https://www.data.gv.at/katalog/dataset/1039ed7e-97fb-435f-b6cc-f6a105ba5e09
shp_streets <- readOGR(paste0(wd_conf_data,
                            "/STRASSENGRAPHOGD/STRASSENGRAPHOGD.shp"))

# change crs
shp_greenspaces <- spTransform(shp_greenspaces, CRSobj= CRS_base[[2]])
shp_streets     <- spTransform(shp_streets    , CRSobj= CRS_base[[2]])

# subset greenspaces to wienerwald, lobau, lainzer tiergarten
shp_greenspaces <- shp_greenspaces[shp_greenspaces$OBJECTID %in% c(1473, 652, 660),]

# add labels
shp_greenspaces$labels <- c("a", "b", "c")

shp_streets            <- shp_streets[shp_streets$REG_STRNAM %in% c("B221") |
                               shp_streets$FEATURENAM %in% c("Kärntner Ring", "Opernring",
                               "Dr.-Karl-Renner-Ring", "Kärntner Ring", "Parkring",
                               "Schottenring", "Schubertring", "Universitätsring", 
                               "Franz-Josefs-Kai", "Stubenring", "Burgring"),]

# add labels
shp_streets$labels <- c(NA, "d", "e", rep(NA, nrow(shp_streets)-3))


# plot
tm_shape(rgb_tr)+
   tm_rgb() +
tm_shape(shp_boundaries) +
  tm_borders(lwd=1.2, col = "red") +
  tm_layout(main.title = "", bg.color = "transparent") +
  tm_text(text = "BEZNR", size = 0.7, col = "red")+
  tm_compass(type = "arrow", position = c("RIGHT", "TOP")) +
  tm_scale_bar() +
  tm_grid(lines = FALSE, labels.size = 0.5, labels.r = c(0,90)) +
  tm_credits("ETRS89", position = c("LEFT", "BOTTOM")) +
  tm_shape(shp_greenspaces) +
  tm_borders("green", lty = "longdash") +
  tm_text(text = "labels", col="pink", size = 0.8, just = "left") +
  tm_shape(shp_streets) +
  tm_lines(col = "yellow", lwd = 0.8) +
  tm_text(text = "labels", just = "top", col = "yellow", size = 0.6)

  



##################end of script###########################################################
##########################################################################################