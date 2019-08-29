# Mapping using "maps" and "mapdata" packages #######
# From http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html#maps-package-and-ggplot

# these are packages you will need, but probably already have.
# Don't bother installing if you already have them
install.packages(c("ggplot2", "devtools", "dplyr", "stringr", "ggmap"))

# some standard map packages.
install.packages(c("maps", "mapdata"))

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(dplyr)
library(stringr)
library(devtools)


w2hr <- map_data("world2Hires")

dim(w2hr)

head(w2hr)

tail(w2hr)

usa <- map_data("usa") # we already did this, but we can do it again
ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) +
  coord_fixed(1.3)

ggplot() +
  geom_polygon(data = usa, aes(x=long, y = lat, group = group), fill = NA, color = "red") +
  coord_fixed(1.3)

gg1 <- ggplot() +
  geom_polygon(data = usa, aes(x=long, y = lat, group = group), fill = "violet", color = "blue") +
  coord_fixed(1.3)
gg1

labs <- data.frame(
  long = c(-122.064873, -122.306417),
  lat = c(36.951968, 47.644855),
  names = c("SWFSC-FED", "NWFSC"),
  stringsAsFactors = FALSE
  )
# ggmap more friendly to csv files, but this probably would do that also

gg1 +
  geom_point(data = labs, aes(x = long, y = lat), color = "black", size = 5) +
  geom_point(data = labs, aes(x = long, y = lat), color = "yellow", size = 4)
# work around to have an outline on the dots-- have a bigger black dot under a smaller yellow dot

### States #### 

states <- map_data("state")
dim(states)
head(states)
tail(states)

ggplot(data = states) +
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") +
  coord_fixed(1.3) +
  guides(fill=FALSE)  # do this to leave off the color legend; if not get a crazy legend that's a bit crazy

west_coast <- subset(states, region %in% c("california", "oregon", "washington"))

ggplot(data = west_coast) +
  geom_polygon(aes(x = long, y = lat), fill = "purple", color = "black")

ggplot(data = west_coast) +
  geom_polygon(aes(x = long, y = lat, group = group), fill = "purple", color = "black") +
  coord_fixed(1.3)

ca_df <- subset(states, region == "california")

head(ca_df)

counties <- map_data("county")
ca_county <- subset(counties, region == "california")

head(ca_county)

ca_base <- ggplot(data = ca_df, mapping = aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) +
  geom_polygon(color = "black", fill = "gray")
ca_base + theme_nothing() # gets rid of the state lines

ca_base + theme_nothing() +
  geom_polygon(data = ca_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA)  # get the state border back on top

##### there's a bunch more here about pop density, but I didn't copy it #######
