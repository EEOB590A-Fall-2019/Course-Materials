# EEOB590A
# Data_wrangling part 2 practice exercise
# practice tidying and wrangling 

library(tidyverse)
library(forcats)

#from the tidy folder, read in the partialtidy file for pollination from last week's assignment

poll <- read_csv("data/tidy/poll_long_partialtidy.csv")

###########################################################
#####Part 1: finish tidying & wrangling dataframe #########

#1) Broad changes to the database

#1a) Change the class of each variable as appropriate (i.e. make things into factors or numeric)

poll <- poll %>%
  mutate_at(vars(uniqueID, island, site, transect, topcolor, bowlcolor, insectorder), 
            factor)

#1b) Change name of "date traps out" and "date traps coll" to "dateout" and "datecoll"
poll <- poll %>% 
  rename(dateout = 'date traps out', 
         datecoll = 'date traps coll')

#2) Fix the errors below within cells 

##2a) Fix the levels of site so that they have consistent names, all in lowercase

poll$site <- as.factor(tolower(poll$site))

poll <- poll %>%
  mutate(site = fct_recode(site, "forbig" = "forbigrid", "race" = "racetrack"))

##2b) What format are the dates in? Do they look okay? 
str(poll$datecoll)

#R is reading them in as a date... we're good to go! 

##2c) Do you see any other errors that should be cleaned up? 
#since we renamed the 

#3) Create a new column for the duration of time traps were out

#poll$duration <- poll$datecoll - poll$dateout # OR

poll <- poll %>%
  mutate(duration = datecoll - dateout)

#4) Arrange data by the number of insects
poll <- poll %>%
  arrange(numinsects)

#5) Print tidied, wrangled database

write.csv(poll, "data/tidy/poll_long_tidy.csv")

#####################################################
####Part 3: start subsetting & summarizing ##########

#6) Make a new dataframe with just the data from Guam at the racetrack site and name accordingly. 
pollG_race <- poll %>%
  filter(island == "Guam", site == "race")

#7) Make a new dataframe with just the uniqueID, island, site, transect, insectorder, numinsects, and duration columns. 

poll_basic <- poll %>%
  select(uniqueID, island, site, transect, insectorder, numinsects, duration)

#8) With the full database (not the new ones you created in the two previous steps), summarize data, to get: 
#8a) a table with the total number of insects at each site

poll_insects_site <- poll %>%
  group_by(site) %>%
  summarize (totalinsects = sum(numinsects, na.rm=T))

#8b) a table that shows the mean number of insects per bowl by island
poll_insects_island <- poll %>%
  group_by(island) %>%
  summarize (meaninsects = mean(numinsects, na.rm=T))

#note -if we want to know the mean insect per transect by island

poll_insects_island_tr <- poll%>%
  group_by(island, site, transect) %>%
  summarize(totalpertr = sum(numinsects, na.rm=T)) %>%
  group_by(island) %>%
  summarize(meaninsects = mean(totalpertr, na.rm=T))

#8c) a table that shows the min and max number of insects per transect
poll_insects_minmax <- poll %>%
  group_by(island, site, transect) %>%
  summarize (mininsects = min(numinsects, na.rm=T), 
             maxinsects = max(numinsects, na.rm=T))

#9a) Figure out which insect order is found across the greatest number of sites

poll_insect_site <- poll %>%
  group_by(insectorder) %>%
  filter(numinsects>0) %>%
  summarize(numsites = n_distinct(site))

poll %>%
  group_by(site, insectorder) %>%
  summarize(numinssite = sum(numinsects, na.rm=T)) %>%
  filter(numinssite >0) %>%
  group_by(insectorder) %>%
  count(insectorder)

#9b) For that insect order, calculate the mean and sd by site. 

#I'm adding in the island and total just for kicks. 

poll_leps <- poll%>%
  filter (insectorder == "Lepidoptera") %>%
  group_by (island, site) %>%
  summarize(totalleps = sum(numinsects, na.rm = T),
            meanleps = mean(numinsects, na.rm = T), 
            sdleps = sd(numinsects, na.rm = T))
