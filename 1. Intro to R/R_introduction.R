# Intro to R Day 1

######## Topics #######
# Getting help
# Working directories
# Using R as a calculator
# Functions
# Downloading new packages
# Creating data and variables
# Preparing and loading data files into R
# Getting to know your data
# Square brackets - like an address for a dataset
# Manipulating parts of data tables

# ----- Getting help --------
# If you know a function name, you can use
#   the question mark ? to open a help file

?mean #opens help file 
?t.test

# Help files tell possible arguments
#   and give examples at the end

help.start()  # opens the links to online manuals and miscellaneous materials

# Or, open help tab (at right) and type name in
# Or, google it! (There are great R forums)

# ----- Working Directories ---------
# Determine your working directory

getwd()

# Set your working directory using setwd()
#   or by using "Set as working director" in the "More"
#   option in the "Files" tab on the right

setwd('/Users/Haldre/Desktop/')


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

?curve #see what the help file says

curve(2*x, from=0,to=8)





# ----- Downloading new packages ------

# If the function you want is in a
#   different package, use install.packages() (or use Packages tab in RStudio)

install.packages("lme4")

# To load this so R can use it, use library() (or check box in Packages tab on RStudio)

library(lme4)





# ----- Creating data and variables ------


# Make a vector with concatenate, c()

c(5, 7, 3, 14)

# Or save this as something

dogAges <- c(5, 7, 3, 14)

# Type the name to see it

dogAges

# Perform functions on vectors

mean(dogAges)

dogAges2 <- dogAges*2
dogAges2

# Combine vectors

dogAges <- cbind(dogAges, dogAges2)
dogAges



# ----- Preparing and loading data files into R ------

#   Can use .csv or .txt files or excel files

# Read file using read.csv, naming it something. Note that this must be in your 
# working directory

spider <- read.csv("1. Intro to R/spider.csv", header = TRUE)

# You can also use use file.choose()
spider <- read.csv(file.choose())






# ----- Getting to know your data ------

# What does R interpret this as? use class()

class(spider)

# Good! R interprets it as a data frame

# Look at the dimensions - rows by cols

dim(spider)

# Look at the first rows with head()

head(spider)

# What are the column names?

colnames(spider)

# How are the rows, columns labeled?

labels(spider)

# Summarize your data

summary(spider)

# R describes data as numerical, factors, and integers
# Use str(data) to see what it is describing your data

str(spider)

# Change class using as.factor(), as.numeric(), as.integer(), as.character()

spider$survey <- as.factor(spider$survey)

str(spider)





# ----- Discussing your data with your computer ------

# To describe cells in your data frame,
#   R uses the form data[i,j]
#   where i is row, j is column
#   Or, data$column to describe columns

# Specific cells
spider[2,5]

# Specific row
spider[2,]

# Specific column
spider[,5]

# OR, data$column

spider$island

# OR, data[['column']]

spider[['island']]




# ----- Manipulating parts of data tables ------

# Create a vector by calculating
# This isnt automatically attached to the "spider" data frame
webs50m <- (spider$tot_webs/spider$length)*50

# To attach, use cbind() to add "disolved" to "flow"
spider <- cbind(spider,webs50m)

# Make sure the new column is there
head(spider)


