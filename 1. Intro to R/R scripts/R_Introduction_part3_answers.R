########## R introduction Part 3 (Thursday, September 12) ############

#Today we will focus on reading in datasets, with some added complexity, and 
#changing the class of variables

#load libraries
library(readr)
library(readxl)
library(lubridate)

#1) Reading in CSV files

#Read in the "transplant_raw.csv" file
transplant_raw <- read_csv("1. Intro to R/data/transplant_raw.csv")

#Read it in again, but assign better column names using principles
#we discussed in class
transplant_raw <- read_csv("1. Intro to R/data/transplant_raw.csv", col_names = c("island", "site", "webnum", "native", "netting", "startdate", "enddate", "totaldays", "spidpres", "webpres", "websizecm"))

#Read it in again and assign appropriate column types (e.g. character, factor, numeric)
transplant_raw <- read_csv("1. Intro to R/data/transplant_raw.csv", col_names = c("island", "site", "webnum", "native", "netting", "startdate", "enddate", "totaldays", "spidpres", "webpres", "websizecm"))

#2) Reading in Excel files

#We are going to work with the "leaf damage ag expt.xls" file. This is the 
#exact file I found from an undergraduate project in 2007. It's not perfect. 
#Let's see how we can fix it. 

#read in the "beans" and "herbivory" worksheets and give each the same name 
#as the worksheet tab they came from

beans <- read_excel("1. Intro to R/data/leaf damage ag expt.xls")
herbivory <- read_excel("1. Intro to R/data/leaf damage ag expt.xls", sheet=2)

# Look at the structure of 'beans'. What class are each of the columns in? 
str(beans)

#Read in the beans worksheet again, and tell R the appropriate class/column type 
#for each column. Note that read_excel doesn't let you choose factor, so use text instead
beans <- read_excel("1. Intro to R/data/leaf damage ag expt.xls", 
                                  col_types = c("text", "text", "text", 
                                                "numeric", "numeric", "text", "numeric", 
                                                "text", "numeric", "text"))

#After you read it in, you realize that the "Number" column indicates the ID 
#of each exclosure, and therefore should be a factor. Change that column to a
#factor. 
beans$Number <- as.factor(beans$Number)

#check the number of levels for this factor to make sure it converted correctly
levels(beans$Number)

#Notice that there are some X's in the leaflet columns of the herbivory worksheet?
#Read it in again, but this time tell R that the X means NA
herbivory <- read_excel("1. Intro to R/data/leaf damage ag expt.xls", sheet = 2, 
                        na = c("", "NA", "X", "x"))

#ADVANCED: Read the herbivory datasheet in again, but omit columns J-L because
#they do not belong with rows 2-6. If you aren't sure how to do this, look
#at the help file for the function that reads in excel files

herbivory <- read_excel("1. Intro to R/data/leaf damage ag expt.xls",  
                        na = c("", "NA", "X", "x"), range = "herbivory!A1:I718")

#3) Dealing with dates

#Read in the "Exploring_dates.xlsx" file. 
Exploring_dates <- read_excel("1. Intro to R/data/Exploring_dates.xlsx")

#Is this object a vector, matrix, dataframe, tibble, array or list? 

#The name of this object is kinda unwieldy. Rename the object "dates"
dates <- Exploring_dates

#What format does R recognize each of the dates as? Which ones did not read in 
#as dates? 
str(dates)

#Create a new column based on the difference in time between date 1 and date 2 
#and name it "duration
duration <- dates$date1 - dates$date2

#ADVANCED: Change the columns that didn't read in correctly into proper dates

#column4
dates$date4a <- ymd(dates$date4) #worked for 2digit days, but not single digit. 

#I think the only way around this is to add a dash after the 5th and 7th digits
#then try again with lubridate
library(stringr)
str_sub(dates$date4, 5, -5) <- "-"
str_sub(dates$date4, 8, -8) <- "-"
dates$date4b <- ymd(dates$date4)
str(dates)

#column6
dates$date6a <- as.Date(dates$date6, origin = "1900-01-01")

