#Intro to R Week 2

#4. Reading in Data 
library(readr) #part of the tidyverse set of packages
library(readxl) #not automatically loaded with tidyverse, needs to be loaded separately

spider <- read.csv("1. Intro to R/data/spider.csv", header = TRUE) #base approach to loading csv's
spidertv <- read_csv("1. Intro to R/data/spider.csv") #readr approach to loading csv's

#what are the differences? 
str(spider)
str(spidertv)

#if you want to specific class, use col_types argument and tell R which column types you want
spidertv2 <- read_csv("1. Intro to R/data/spider.csv", col_types = "iDffnffnnnnn") #readr approach to loading csv's 

#Can also add column names in here too
spidertv3 <- read_csv("1. Intro to R/data/spider.csv", col_names = c("year", "date", "season", "island", "birddensity", "birdpres", "site", "surveynum", "totalwebs", "time", "length", "webs10m"), skip=1) #note that when you use col_names, the first row of data is read in as data, so need to use skip=1 to skip the header row

#If you want to read certain things in as "NA", use na= argument
spidertv4 <- read_csv("1. Intro to R/data/spider.csv", na = c("na", "NA", ""))

# Reading in excel files is easy too, with readxl package
library(readxl)

#Can read in the second sheet by writing "sheet = 2"
spiderprey <- read_excel("1. Intro to R/data/Prey_Capture_Final_Do_Not_Touch.xlsx", sheet = 2)

#how does this compare to the csv files we read in earlier? (note - it's a different dataset)
str(spiderprey)

#Can specify col_names, col_types, na the same way as in read_csv()


#5. Tibbles
str(spider) #created using base read.csv - is a data frame
str(spidertv) #created using read_csv in tidyverse, is a tibble

#Tibbles only show the first 10 rows when you 'print' them
spider
spidertv

#Tibbles have different properties when using square brackets [,]
spider[2,3]
spidertv[2,3]

#change data frame to tibble
spider_tb <- as.tibble(spider)
str(spider_tb) #note that it kept all of the classes from the dataframe

#change tibble to data frame
spidertv_df <- as.data.frame(spidertv)
str(spidertv_df)

#6. Explore your data
dim(spider)
nrow(spider)
ncol(spider)
length(spider) #same as ncol if talking about entire dataframe
head(spider)
tail(spider)
colnames(spider)
rownames(spider)
str(spider)
summary(spider)

#7. Change class of data
spider$site <- as.character(spider$site)
levels(spider$site)
head(spider$site)

spider$site <- as.factor(spider$site)
levels(spider$site)
head(spider$site)

spider$site <- as.numeric(spider$site)
levels(spider$site)
head(spider$site)

#other functions
as.integer()
as.logical()

#dealing with dates
library(lubridate)
str(spidertv) #date is a character class in this tibble

spidertv$date2 <- dmy(as.character(spidertv$date)) #but doesn't work for the ones that aren't dmy format... 








