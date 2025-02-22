

######
## https://mailman.stat.ethz.ch/pipermail/r-help/2016-June/439123.html



library(maptools)
library(ggplot2)
library(ggalt)
library(ggthemes)
library(tibble)
library(viridis)
library(RColorBrewer)

#############

library(plotly)
library(htmlwidgets)

italy_map <- map_data("italy")

# https://cengel.github.io/R-data-viz/interactive-graphs.html


generate_tab <- function(val){
  
  choro_dat <- data_frame(region=unique(italy_map$region),
                          value = val)
  
  dif <- max(choro_dat$value) - min(choro_dat$value)
  part <- as.integer(dif/5)
  
  # from il min to part # 1
  # part to part*2      # 2
  # part*2 to part*3    # 3
  # part*3 to part*4    # 4
  # part* 4 to max      # 5
  
  index_val <- rep(NA, length(choro_dat$value))
  for(i in 1:length(choro_dat$value)){
    if(choro_dat$value[i] <= part){index_val[i]<-1}
    else if(choro_dat$value[i] >= part & choro_dat$value[i] <= part*2){index_val[i]<-2}
    else if(choro_dat$value[i] >= part*2 & choro_dat$value[i] <= part*3){index_val[i]<-3}
    else if(choro_dat$value[i] >= part*3 & choro_dat$value[i] <= part*4){index_val[i]<-4}
    else if(choro_dat$value[i] >= part*4){index_val[i]<-5}
  }
  
  # redefine choro
  choro_dat <- data_frame(region=unique(italy_map$region),
                          value = val,
                          index = index_val)
  return(choro_dat)
}




map_reg <- function(val){
  
  choro_dat <- data_frame(region=unique(italy_map$region),
                          value = val)
  
  dif <- max(choro_dat$value) - min(choro_dat$value)
  part <- as.integer(dif/5)
  
  # from il min to part # 1
  # part to part*2      # 2
  # part*2 to part*3    # 3
  # part*3 to part*4    # 4
  # part* 4 to max      # 5
  
  index_val <- rep(NA, length(choro_dat$value))
  for(i in 1:length(choro_dat$value)){
    if(choro_dat$value[i] <= part){index_val[i]<-as.integer(1)}
    else if(choro_dat$value[i] >= part & choro_dat$value[i] <= part*2){index_val[i]<-as.integer(2)}
    else if(choro_dat$value[i] >= part*2 & choro_dat$value[i] <= part*3){index_val[i]<-as.integer(3)}
    else if(choro_dat$value[i] >= part*3 & choro_dat$value[i] <= part*4){index_val[i]<-as.integer(4)}
    else if(choro_dat$value[i] >= part*4){index_val[i]<-as.integer(5)}
  }
  
  lab_1 <- as.character(paste("From", 0, "to", part))
  lab_2 <- as.character(paste("From", part, "to", part*2))
  lab_3 <- as.character(paste("From", part*2, "to", part*3))
  lab_4 <- as.character(paste("From", part*3, "to", part*4))
  lab_5 <- as.character(paste("From", part*4, "to", max(choro_dat$value)))
  
  # redefine choro
  choro_dat <- data_frame(region=unique(italy_map$region),
                          value = val,
                          index = index_val)
  
  
  #italy_proj <- "+proj=aea +lat_1=38.15040684902542 +lat_2=44.925490198742295 +lon_0=12.7880859375"
  gg <- ggplot()
  gg <- gg + geom_map(data=italy_map, map=italy_map,
                      aes(map_id=region), #)+ expand_limits(x = italy_map$long, y = italy_map$lat)
                      color="#b2b2b2", size=0.1) + expand_limits(x = italy_map$long, y = italy_map$lat)
  
  gg <- gg + scale_fill_gradient(low="yellow", high="red",
                                 labels = c(lab_1, lab_2, lab_3, lab_4, lab_5), name="Num of cases")

  gg <- gg + geom_map(data=choro_dat, map=italy_map,
                      aes(fill=index, map_id=region) ,
                    color="black", size=.2)
  gg <- gg + theme_map()
  
  gg <- gg + theme(legend.position=c(0.7, 0.6)) 
  
  return(gg)
  
}






map_reg_dat <- function(dat){

  # dataset in input
  #choro_dat <- data_frame(region=unique(italy_map$region),
  #                        value = val,
  #                        index = index_val)
  
  #italy_proj <- "+proj=aea +lat_1=38.15040684902542 +lat_2=44.925490198742295 +lon_0=12.7880859375"
  gg <- ggplot()
  gg <- gg + geom_map(data=italy_map, map=italy_map,
                      aes(map_id=dat$region), #)+ expand_limits(x = italy_map$long, y = italy_map$lat)
                      color="#b2b2b2", size=0.1) + expand_limits(x = italy_map$long, y = italy_map$lat)
  
  gg <- gg + scale_fill_gradient(low="yellow", high="red",
                                 labels = c(lab_1, lab_2, lab_3, lab_4, lab_5), name="Num of cases")
  
  gg <- gg + geom_map(data=dat, map=italy_map,
                      aes(fill=index, map_id=region) ,
                      color="black", size=.2)
  gg <- gg + theme_map()
  
  gg <- gg + theme(legend.position=c(0.85, 1.6)) 
  
  return(gg)
  
}







