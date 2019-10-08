# 26 September 2019 ####

#data wrangling part 1, practice script
#we will be working with a real insect pan traps dataset that I've amended slightly in order to practice the skills from Tuesday. 

#1) load libraries - you will need tidyverse and readxl

library(tidyverse)
library(readxl)

#2) Read in data

poll <- read_excel("data/raw/Data_wrangling_day1_pollination.xlsx")

#3) rename columns. Leave insect families with capital letters, but make all other columns lowercase. Remove any spaces. Change "location" to "site". Change "tract" to "transect". 

poll <- poll %>%
  rename(island = Island, 
         site = Location, 
         transect = Tract,
         topbowl = 'Top color - Bowl color',
         other = Other)

colnames(poll)

#4) Add missing data. Note that the people who entered the data did not drag down the island or location column to fill every row. 

poll <- poll %>%
  fill(island, site) 

view(poll)

#5) Separate "Top color - Bowl color" into two different columns, with the first letter for the top color and the second letter for the bowl color. We do not need to save the original column. 
poll <- poll %>%
  separate(topbowl, into=c("topcolor", "bowlcolor"), sep="-", remove = T) 
view(poll)

#6) Use the complete function to see if we have data for all 3 transects at each location. Do not overwrite the poll dataframe when you do this. 
poll_complete <- poll %>%
  complete(site, transect)

#which transects appear to be missing, and why? 

missing <- poll_complete[is.na(poll_complete$island),]

#7) Unite island, site, transect into a single column with no spaces or punctuation between each part. Call this column uniqueID. We need to keep the original columns too. 

poll <- poll %>%
  unite(uniqueID, c(island, site, transect), sep="", remove=F)


#8) Now, make this "wide" dataset into a "long" dataset, with one column for the insect orders, and one column for number of insects. 

poll_long <- poll %>%
  gather(insectorder, numinsects, 7:19)

#9) And just to test it out, make your "long" dataset into a "wide" one and see if anything is different. 
poll_wide <- poll_long %>%
  spread(insectorder, numinsects)

#are you getting an error? Can you figure out why? 

#10) Now, join the "InsectData" with the "CollectionDates" tab on the excel worksheet. You'll need to read it in, and then play around with the various types of 'mutating joins' (i.e. inner_join, left_join, right_join, full_join), to see what each one does to the final dataframe. 

dates <- read_excel("data/raw/Data_wrangling_day1_pollination.xlsx", sheet = 2)

polldate_inner <- poll %>%
  inner_join(dates)

polldate_left<- poll%>%
  left_join(dates)

polldate_right <- poll%>%
  right_join(dates)

polldate_full <- poll%>%
  full_join(dates)

#create a csv with the long dataframe, including dates
poll_long <- poll_long %>%
  inner_join(dates)

write.csv(poll_long, "data/tidy/poll_long_partialtidy.csv")
