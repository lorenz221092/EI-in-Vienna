# script:  1-2_data_sentinel
# purpose: load satelite images
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




# read shape file for spatial extent
shp_boundaries <- readOGR("~/BEZIRKSGRENZEOGD/BEZIRKSGRENZEOGDPolygon.shp")


# run 
out_paths <- sen2r(
  gui = FALSE,
  preprocess = TRUE,                            # Process downloaded data
  sel_sensor = c("s2a", "s2b"),                 # Download from both satellites S2 A and B
  #downloader = "aria2",                        # Faster download tool
  index_source = "BOA",                         # Use BOA to calculate NDVI, etc
  step_atmcorr = "auto",                        # Process BAO is not available from SciHub
  clip_on_extent = TRUE,                        # Clip bounding box to reduce image size
  extent_as_mask = TRUE,                        # Keep only pixels within Vienna polygon
  parallel = 4,                                 # Use parallel processing 
  outformat = "GTiff",                          # For of output raster files
  extent = shp_boundaries,                      # Vienna shape file
  extent_name = "Vienna",                       # Name output Viennna 
  timewindow = c(as.Date("2017-06-01"), as.Date("2020-08-31")),
  timeperiod = "seasonal",# Load summer 2019
  list_prods = c("BOA","SCL"),                  # Products to be computed
  list_indices = c("NDVI","MSAVI2"),            # Indices to be computed
  list_rgb = c("RGB432B"),                      # RGB images to be computed
  mask_type = "cloud_and_shadow",               # Surface classification cloud/shadow
  max_mask = 10,                                # Max threshold of 10 perc
  path_l2a = "~/l2a",                           # Output path for l2a products
  path_out = "~/out",                           # Output path for Sent2 procucts
  path_l1c = "~/l1c"
)





##################end of script###########################################################
##########################################################################################