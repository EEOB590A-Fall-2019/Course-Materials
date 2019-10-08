#EEOB590: Data wrangling Part 2

#Use this script to:
#Part 2: finish getting dataframe tidied and wrangled
  #1) Fix cells within columns (change class, change names of levels of factor (forcats package), tolower/toupper, reorder levels of factor, trimws, lubridate)
  #2) Create new columns (mutate)
  #3) Arrange data by the levels of a particular column (arrange)
  #4) Print tidied, wrangled database

#Part 3: start subsetting & summarizing
  #5) Subset data (filter, select)
  #6) Summarize data (summarise)
  #7) Group data (group_by)

library("tidyverse")
library("lubridate")
library("readxl")
library("forcats")

##### Step 1) Load tidy data, explore ########
transplant <- read_csv("data/tidy/transplant_tidy.csv")
str(transplant)
summary(transplant)

#change characters to factors where necessary
transplant <- transplant %>%
  mutate_at(vars(island, site, web, native, netting, spidpres), 
            factor)

##### Step 1: Fix cells within columns (e.g. naming, capitalization) #####

summary(transplant) #need to fix capitalization, spelling, whitespace (maybe)

#1.1: change levels within a column so they are lower case.Note that this creates a character vector, so need to mutate back to factor.
levels(transplant$island)
transplant$island <- tolower(transplant$island)
transplant$site <- tolower(transplant$site)
levels(transplant$island)

transplant <- transplant %>%
  mutate_at(vars(island, site), factor)

levels(transplant$island)

#1.2: Change levels of a variable. There are a lot of ways to do this. Here is the forcats approach

transplant <- transplant %>%
  mutate(island = fct_recode(island, "saipan" = "siapan", "guam" = "gaum"))

levels(transplant$island)

#1.3: Get rid of ghost levels (not always necessary, but sometimes you get rid of a level and R still thinks it is there)
transplant$island <- droplevels(transplant$island) # or
transplant$island <- factor(transplant$island)
levels(transplant$island)

#1.4: Re-order levels within a variable.
transplant$island <- factor(transplant$island, levels = c("saipan", "guam"))
levels(transplant$island)

#1.5: delete a certain # of characters from the values within a vector
#this is saying "keep the 1st-4th elements (start at 1, stop at 4)".
levels(transplant$site)
transplant$site<-as.factor(substr(transplant$site, 1, 4)) #this makes all levels 4 characters long
levels(transplant$site)

#1.6: Remove trailing whitespace
transplant$site <- as.factor(trimws(transplant$site))

#1.7: Center continuous predictors and make new column for this variable, may help with convergence
transplant$websize_c <- as.numeric(scale(transplant$websize))

#1.8: Deal with dates
#Change date format to standard yyyymmdd format
#helpful site: https://www.r-bloggers.com/date-formats-in-r/
class(transplant$startdate)

# use lubridate to tell R the format of hte date
transplant$startdate <- dmy(transplant$startdate)
transplant$enddate <- dmy(transplant$enddate)

#now, can do math on your dates!
transplant$duration <- transplant$enddate - transplant$startdate
transplant$duration <- as.numeric(transplant$duration)
summary(transplant$duration)

###2) Create new columns (mutate) ##################
transplant$webarea <- ((transplant$websize/2)/100)^2*pi #base R approach; #assume circle, divide in half to get radius, divide by 100 to get from cm to m, calculate area

mutate(transplant, webarea = ((websize/2)/100)^2*pi) #tidyverse

transplant %>%
  mutate(webarea = ((websize/2)/100)^2*pi) %>%
  head()      #tidyverse with piping

####3) Arrange rows of data by the levels of a particular column (arrange)
#default goes from low to high
arrange(transplant, websize)  #arranging transplant rows based on websize, without using piping

#with piping
transplant <- transplant %>%
  arrange(websize)

#use desc inside the arrange fx to go from high to low
transplant %>%
  arrange(desc(websize))

###4) Print tidy, wrangled database

write.csv(transplant, "data/tidy/transplant_tidy_clean.csv", row.names = F)

########################################################################
#Part 3: Subsetting and grouping

#2) Subset data (filter, select)
#use filter to extract rows according to some category
transplant_guam <- transplant %>%
  filter(island == "guam", site == "anao")

#use select to choose columns
basic_transplant <- transplant %>%
  select(island, site, websize, duration)

transplant %>%
  select(island, site, websize, duration)

#3) Summarize data (summarise, count) #################3
#use summarize to compute a table using whatever summary function you want (e.g. mean, length, max, min, sd, var, sum, n_distinct, n, median)
trans_summ <- transplant %>%
  summarise(avg = mean(websize), numsites = n_distinct(site))

#use count to count the number of rows in each group
count(transplant, site) #base R approach

transplant %>%
  count(site)  #piping approach

##### 4 Group data (group_by) ################
#use group_by to split a dataframe into different groups, then do something to each group

transplant %>%
  group_by(island) %>%
  summarize (avg = mean(websize))

trans_summ <- transplant %>%
  group_by(island, site, netting) %>%
  summarize (avgweb = mean(websize),
            avgduration = mean(duration))



###7) Print summary database

write.csv(trans_summ, "data/tidy/transplant_summary.csv", row.names=F)

