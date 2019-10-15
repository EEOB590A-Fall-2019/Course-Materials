#Data Exploration and visualization Day 1
#Haldre Rogers
#EEOB590

library(ggplot2)
library(tidyverse)

transplant<-read.csv("data/tidy/transplant_tidy_clean.csv", header=T)

str(transplant)

#Get summary data

## Explore using tables
#table, ftable
with(transplant, table(site, native))

#ftable makes a table with three variables more visually appealing
with(transplant, ftable(island, netting, spidpres))

#using dplyr package functions
transplant %>%
  count(site, native)

transplant %>%
  group_by(island, netting) %>%
  count(spidpres)

transplant %>% 
  group_by(island, native, netting) %>% 
  summarize (mean=mean(websize)) 

#Arrange - Order rows by values of a column (low to high). 
transplantord <- transplant %>% 
  arrange(island, duration) 

#play around with this- what else might you want to summarize? 

##############################################
######basic visualization tools ##############
##############################################
#first change factors to factors

######## ggplot #######
#Resources
	# http://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html
	# http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/

#aes = aesthetic means "something you can see"
#geom's: http://sape.inf.usi.ch/quick-reference/ggplot2/geom. A plot must have at least one geom; there is no upper limit.

#histogram - to look at variation within continuous variables
durationhist <- ggplot(data = transplant, aes(duration))+
              geom_histogram()

#barplot  - to count number of rows per category of a variable
ggplot(transplant, aes(site))+
  geom_bar()

#boxplot - to summarize variation in continuous variable across categorical variables
ggplot(transplant, aes(netting, duration))+
      geom_boxplot() #plot response and predictors, continuous data

#create different boxplots for each island
ggplot(transplant, aes(netting, duration, color=island))+
    geom_boxplot() 

#geom_point for two continuous variables - scatterplot
ggplot(transplant, aes(websize, duration))+
  geom_point()

#add facet_grid to show other variables
ggplot(transplant, aes(websize, duration))+
  geom_point()+
  facet_grid(netting~island)


                         
