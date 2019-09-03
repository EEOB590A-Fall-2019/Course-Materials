# RWorkshopDay1.R

# topics
# Using R as a calculator
# Functions
# Getting help
# Downloading new packages
# Creating data and variables
# Preparing and loading data files into R
# Getting to know your data
# Discussing your data with your computer
# Manipulating parts of data tables

#then try it yourself with a new dataset!


# ----- Using R as a calculator ------
1+2
cos(pi)

# Arithmetic
#  +  add
#  -  subtract
#  *  multiply
#  /  divide
#  ^  exponent

# Relational
#  >   greater, less than
#  >=  greater than or equal to
#  !=  not equal to

# Logical
#  !  not
#  &  and
#  |  or





# ----- Functions ------

# Have form: function(argument,argument,argument,...)

# Here, curve is the function and it can interpret
#   the 2*x as the function I want to graph and
#   "from" and "to" as arguments to specify x axis length

curve(2*x, from=0,to=8)





# ----- Getting help ------

# If you know a function name, you can use
#   the question mark ? to open a help file

?t.test

# Help files tell possible arguments
#   and give examples at the end

# Or, open help tab (at right) and type name in
# Or, google it! (There are great R forums)






# ----- Downloading new packages ------

# If the function you want is in a
#   different package, use install.packages() (or use Packages tab in RStudio)

install.packages("lme4")

# To load this so R can use it, use library() (or check box in Packages tab on RStudio)

library(lme4)





# ----- Creating data and variables ------



# Make a vector with concatenate, c()

c(1,2,3,4,5)

# Or save this as something

myvector <- c(1,2,3,4,5)

# Type the name to see it

myvector

# Perform functions on vectors

mean(myvector)

myvector2 <- myvector*2
myvector2

# Combine vectors

myvectors <- cbind(myvector, myvector2)
myvectors






# ----- Preparing and loading data files into R ------

# Determine your working directory

getwd()

# Set your working directory using setwd()
#   or by using "Set as working director" in the "More"
#   option in the "Files" tab on the right

setwd('/Users/Haldre/Desktop/')

# R likes .csv or .txt files
#   so use Excel to save as one of those

# Read file using read.csv, naming it something

data <- read.csv('RWorkshopDay1.csv', header=TRUE)

# You can ignore the wd and use file.choose()
# data <- read.csv(file.choose())






# ----- Getting to know your data ------

# What does R interpret this as? use class()

class(data)

# Good! R interprets it as a data frame

# Look at the dimensions - rows by cols

dim(data)

# Look at the first rows with head()

head(data)

# What are the column names?

colnames(data)

# How are the rows, columns labeled?

labels(data)

# Summarize your data

summary(data)

# R describes data as numerical, factors, and integers
# Use str(data) to see what it is describing your data

str(data)

# Change class using as.factor(), as.numeric(), as.integer(), as.character()

data$Plot <- as.factor(data$Plot)

str(data)





# ----- Discussing your data with your computer ------

# To describe cells in your data frame,
#   R uses the form data[i,j]
#   where i is row, j is column
#   Or, data$column to describe columns

# Specific cells
data[2,5]

# Specific row
data[2,]

# Specific column
data[,5]

# OR, data$column

data$Veg

# OR, data[['column']]

data[['Veg']]






# ----- Manipulating parts of data tables ------


flow <- read.table('RWorkshopDay2.txt',header=T) 
# an alternative to read.csv if you can produce a text file

head(flow)
flow$init_g

# Create a vector by calculating
# This isnt automatically attached to the "flow" data frame
dissolved <- (flow$init_g - flow$final_g)/(flow$days)

# To attach, use cbind() to add "disolved" to "flow"
flow <- cbind(flow,dissolved)

# Make sure the new column is there
head(flow)


### now it's your turn #### 

#read in spider.csv 
#explore dataset -what is min, max, average for the total # of webs? 
#create a vector describing the number of webs per meter
#make a histogram of the total number of webs
