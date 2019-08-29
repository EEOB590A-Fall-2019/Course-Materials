##### ggmap ######
# From http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html#maps-package-and-ggplot

# these are packages you will need, but probably already have.
# Don't bother installing if you already have them
install.packages(c("ggplot2", "devtools", "dplyr", "stringr"))

# some standard map packages.
install.packages(c("maps", "mapdata"))

# need to install ggmap a special way 
install.packages("ggmap")

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(dplyr)
library(stringr)
library(devtools)

# uses true decimal point lat long-- not UTMs-- need to find conversion

sisquoc <- read.table("mapping/sisquoc-points.txt", sep = "\t", header = TRUE) #gets data from your own gps points
sisquoc

sbbox <- make_bbox(lon = sisquoc$lon, lat = sisquoc$lat, f = .1) # limits the map to your defined area
sbbox

# First get the map. By default it gets it from Google.  I want it to be a satellite map
sq_map <- get_map(location = sbbox, maptype = "satellite", source = "google")

ggmap(sq_map) + geom_point(data = sisquoc, mapping = aes(x = lon, y = lat), color = "red") # telling R where to get data, to use lat/long, what color you want your points

# compute the mean lat and lon
ll_means <- sapply(sisquoc[2:3], mean) # giving it the means of lat and long from middle of bounding box
sq_map2 <- get_map(location = ll_means,  maptype = "satellite", source = "google", zoom = 15)

ggmap(sq_map2) +
  geom_point(data = sisquoc, color = "red", size = 4) +
  geom_text(data = sisquoc, aes(label = paste("  ", as.character(name), sep="")), angle = 60, hjust = 0, color = "yellow")


sq_map3 <- get_map(location = ll_means,  maptype = "terrain", source = "google", zoom = 15)

# for this map just making the terrain clearer-- can see that points collected in a valley, has contour lines
ggmap(sq_map3) +
  geom_point(data = sisquoc, color = "red", size = 4) +
  geom_text(data = sisquoc, aes(label = paste("  ", as.character(name), sep="")), angle = 60, hjust = 0, color = "yellow")

##### Bike ride
bike <- read.csv("bike-ride.csv")
head(bike)
View(bike)

#location here is more exacting-- not just making box, making a more zoomed in map
bikemap1 <- get_map(location = c(-122.080954, 36.971709), maptype = "terrain", source = "google", zoom = 14)

ggmap(bikemap1) +
  geom_path(data = bike, aes(color = elevation), size = 3, lineend = "round") +
  scale_color_gradient(colours = rainbow(7), breaks = seq(25, 200, by = 25))

#### Fish sampling ####
bc <- readRDS("bc_sites.rds")
View(bc)

# look at some of it:
# %>%-- comparing sequential things
# so taking output from one thing you analyze and plugs it into the next thing
bc %>% select(state_or_province:sub_location, longitude, latitude)

bc %>% group_by(sector, region, area) %>% tally()

# compute the bounding box-- calculating the square in which all of your points fit
bc_bbox <- make_bbox(lat = latitude, lon = longitude, data = bc)
bc_bbox

# grab the maps from google
bc_big <- get_map(location = bc_bbox, source = "google", maptype = "terrain")

# plot the points and color them by sector
ggmap(bc_big) +
  geom_point(data = bc, mapping = aes(x = longitude, y = latitude, color = sector))

ggmap(bc_big) +
  geom_point(data = bc, mapping = aes(x = longitude, y = latitude, color = region)) # can assign color to all kinds of parameters that you keep track of in the field

region_plot <- function(MyRegion) {
  tmp <- bc %>% filter(region == MyRegion)
  bbox <- make_bbox(lon = longitude, lat = latitude, data = tmp)
  mymap <- get_map(location = bbox, source = "google", maptype = "terrain")
  # now we want to count up how many areas there are
  NumAreas <- tmp %>% summarise(n_distinct(area))
  NumPoints <- nrow(tmp)

  the_map <- ggmap(mymap) +
    geom_point(data = tmp, mapping = aes(x = longitude, y = latitude), size = 4, color = "black") +
    geom_point(data = tmp, mapping = aes(x = longitude, y = latitude, color = area), size = 3) +
    ggtitle(
      paste("BC Region: ", MyRegion, " with ", NumPoints, " locations in ", NumAreas, " area(s)", sep = "")
      )

  ggsave(paste("bc_region", MyRegion, ".pdf", sep = ""), the_map, width = 9, height = 9)
}

dump <- lapply(unique(bc$region), region_plot)
