########## R introduction Part 3 (Thursday, September 12) ############

#Today we will focus on reading in datasets, with some added complexity, and 
#changing the class of variables

#1) Reading in CSV files

#Read in the "transplant_raw.csv" file

#Read it in again, but assign better column names using principles
#we discussed in class

#2) Reading in Excel files

#Read in the "leaf damage ag expt.xls" file. This is the exact file I found from 
#an undergraduate project in 2007. It's not perfect. Let's see how we can fix it. 

#read in the "beans" and "herbivory" worksheets and give each the same name 
#as the worksheet tab they came from

# Look at the structure of 'beans'. What class are each of the columns in? 


#Read in the beans worksheet again, and tell R the appropriate class/column type 
#for each column. Note that read_excel doesn't let you choose factor, so use text instead


#After you read it in, you realize that the "Number" column indicates the ID 
#of each exclosure, and therefore should be a factor. Change that column to a
#factor. 

#check the number of levels for this factor to make sure it converted correctly

#Notice that there are some X's in the leaflet columns of the herbivory worksheet?
#Read it in again, but this time tell R that the X means NA


#ADVANCED: Read the herbivory datasheet in again, but omit columns J-L because
#they do not belong with rows 2-6. If you aren't sure how to do this, look
#at the help file for the function that reads in excel files


#3) Dealing with dates

#Read in the "Exploring_dates.xlsx" file. 

#Is this object a vector, matrix, dataframe, tibble, array or list? 

#The name of this object is kinda unwieldy. Rename the object "dates"

#What format does R recognize each of the dates as? Which ones did not read in 
#as dates? 

#Create a new column based on the difference in time between date 1 and date 2 
#and name it "duration

#ADVANCED: Change the columns that didn't read in correctly into proper dates
