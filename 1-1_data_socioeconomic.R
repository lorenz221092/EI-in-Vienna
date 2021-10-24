# script:  1-1_data_socioeconomic
# purpose: load and edit socioeconomic data
# project: environmental ineq paper
# author:  lorenz
##########################################################################################
##########################################################################################




##################loading data############################################################

# load socioeconomic data 
shp_kaufkraft <-    readOGR(dsn=paste0(wd_conf_data,
                                       "/census2019/Paket_Kaufkraft-w_2019"),
                            stringsAsFactors = FALSE,
                            layer="kaufkraft_raster250m_w")

shp_bevoelkerung <- readOGR(dsn=paste0(wd_conf_data,
                                       "/census2019/Paket_Bevoelkerung-w_2019"), 
                            stringsAsFactors = FALSE, 
                            layer="bevoelkerung_raster250_w")



##################subsetting and merging##################################################


# select relevant variables from bevoelkerung data

                       #cell id     #gemeinde id      #federal state id  #population
vars_bevoelkerung <- c("ID",        "A08_ID",         "A01_ID",          "POP",     
                       #austrian origin   #born in austria  #austrian citizens  
                       "HER_AUT",         "GEB_AUT",        "STA_AUT",          
                       #germans   #eu citizens   #above 64   #above 84   
                       "HER_DEU",  "STA_EU",     "ALL_10",   "ALL_11" )
                      
                      
shp_bevoelkerung  <- shp_bevoelkerung[,vars_bevoelkerung]

# rename variables
names(shp_bevoelkerung) <- c("ID",  "Distr", "State_ID", "Population",
                             "AUT_Origin", "AUT_Born", "AUT_Citizen",
                             "GER_Origin", "EU_Citizen", "Older_64", "Older_84" )


# select relevant variables from kaufkraft data

                     #cell id      #avg income   #per capita index income  
vars_kaufkraft <-    c("ID",      "EURO_PK",    "IDX_BL_PK", "EURO_SUM")

shp_kaufkraft  <-    shp_kaufkraft[,vars_kaufkraft]

# rename variables
names(shp_kaufkraft)    <-c("ID", "Avg_Income", "Index_Income", "Tot_Income")


# merge shapes
shp_socioecon  <- merge(shp_bevoelkerung, shp_kaufkraft)


# subset vienna census cells
shp_socioecon <- shp_socioecon[shp_socioecon$`State_ID`==9,]



##################fixing issues in raw data###############################################


# substring district id to simple district number
shp_socioecon$Distr       <- substr(shp_socioecon$Distr, 2, 3 )


# who is left?
(n_cells_1 <- nrow(shp_socioecon))          
(n_pop_1   <- sum(shp_socioecon$Population))
(perc_cells1  <- n_cells_1*100/n_cells_0)   


# all variables with pop<4 miss imporant variables --> omit
shp_socioecon <- shp_socioecon[shp_socioecon$Population>3,]


# who ist left?
(n_cells_2    <- nrow(shp_socioecon))                   #3744 cells left
(n_pop_2      <- sum(shp_socioecon$Population))         #capture 1,896,706 people
(perc_cells2  <- n_cells_2*100/n_cells_0)               #47.76 % of cells left
(perc_pop2    <- n_pop_2*100/n_pop_1)                   #99.98 % of population left


# all NAs are due to missing income data -> also get rid of them for same reason (also 0)
shp_socioecon <- sp.na.omit(shp_socioecon, margin = 1)  #NAs
shp_socioecon <- shp_socioecon[shp_socioecon$Avg_Income>0,] #zeros

# who is left?
(n_cells_3    <- nrow(shp_socioecon))                   #3530 cells left
(n_pop_3      <- sum(shp_socioecon$Population))         #capture 1,845,859 people
(perc_cells3  <- n_cells_3*100/n_cells_0)               #45.02 % of cells left
(perc_pop3    <- n_pop_3*100/n_pop_1)                   #97.30 % of population left




##################create new variables####################################################

# Non-Austrian Origin Definition
shp_socioecon$Not_AUT_Origin     <- shp_socioecon$Population - shp_socioecon$AUT_Origin  

# People older than 64
shp_socioecon$Seniors            <- shp_socioecon$Older_64 + shp_socioecon$Older_84

# Percentage Non-Austrian-Origin Definition
shp_socioecon$`Perc_Not_AUT_Orig` <- shp_socioecon$Not_AUT_Origin*100/
                                     shp_socioecon$Population 

# Percentage of People older than 64
shp_socioecon$`Perc_Seniors`     <-  shp_socioecon$Seniors* 100/
                                     shp_socioecon$Population




##################create district dummies#################################################

# create dummies for all districts with fastDummies package
df_dummies <- dummy_cols(shp_socioecon, "Distr")


# crop the dataframe as we only need the dummies
df_dummies <- df_dummies[,c(1,(ncol(df_dummies)-22):ncol(df_dummies))]






##################final refinements#######################################################

# change crs of socioeconomic data data to crs of base data
shp_socioecon <- spTransform(shp_socioecon, CRSobj= CRS_base[[2]])

# remove some unnecessary variables
shp_socioecon <-  shp_socioecon[,-3]




# purge environment
rm("shp_kaufkraft", "shp_bevoelkerung", "vars_bevoelkerung", "vars_kaufkraft")
##################end of script###########################################################
##########################################################################################