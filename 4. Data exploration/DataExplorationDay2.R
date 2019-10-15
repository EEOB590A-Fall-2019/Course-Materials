#Data Exploration and visualization
#Haldre Rogers
#EEOB590

#Research Question: 
#Do spiders build smaller webs when birds are present? If so, then web size should be smaller on Saipan than on Guam. (note the N=1 problem here).
#Does this vary depending on whether spider was transplanted or found in the area? 

#Response: websize, duration
#Predictor: island, 
#random effect: site

library(ggplot2)
library(skimr)
library(tidyverse)
library(DataExplorer)

transplant<-read.csv("data/tidy/transplant_tidy_clean.csv", header=T)
nrow(transplant) #91 rows

#1) check structure to make sure everything is in correct class
str(transplant)

#2) Subset to the dataset you will use for the analysis
#could use subset that was actually transplanted rather than ones that were observed in place. If we did this, we would do all data exploration using this filtered dataset.

truetrans <- transplant %>%
  filter(native == "no")

nrow(truetrans)#62 rows 

###### Data Exploration ############

#try these two functions, from the skimr and DataExplorer packages
skim(transplant)
create_report(transplant)

##a.  Outliers 
#i.	plot all continuous response and predictors to check for outliers  (only with continuous data)
#1.	Use histogram or dotplot, identify outliers
ggplot(transplant, aes(websize))+
  geom_histogram()

dotchart(transplant$websize)

ggplot(transplant, aes(webarea))+
  geom_histogram()

ggplot(transplant, aes(duration))+
  geom_histogram()

dotchart(transplant$duration)

#no major outliers in Y, all X's are categorical

#b.	Examine Zero inflation Y
#Not applicable for websize, because response is continuous
#duration doesn't have any zero's so not an issue here. 


#c.	Collinearity X: correlation between covariates ()
#i.	Plot each predictor against each other (since categorical, can't test this directly)


#d.	Look at relationships of Y vs X’s to see if homogenous variances at each X value, linear relationships
# i.	Plot response against each predictor and random effect. 
ggplot(transplant, aes(native, websize, color=island))+
  geom_boxplot()

#maybe less variance on Saipan than on Guam, but nothing stands out as terrible. 

ggplot(transplant, aes(site, websize))+
  geom_boxplot() #mtr1 not sampled as well, has less variance

#e.	Independence Y - are Y's independent? 
#1.	Is there a pattern across time or space that is not incorporated in the model? 
ggplot(transplant, aes(native, websize, color=island))+
  geom_boxplot()+
  facet_grid(.~site)
#But nothing really stands out in terms of site-level effects. NBLAS higher than Anao, 
#anao doens't have "yes" native spiders, MTR doesn't have "no" native spiders

#ii. Are there other potential factors that reduce independence of Y’s? 
#timing is similar, can't think of anything else that might matter. 

#f.	Sufficient data?  
##As a rule of thumb, (all models), should have 15 to 20 observations for each parameter. So, if have 50 observations, should really only have 3 parameters. 
#6 parameters max here

#i.	Do all levels of island have adequate samples of at each level of native? 	Examine interactions
#Is the quality of the data good enough to include them? (i.e. do we have enough samples for each level of the interaction?) 
with(transplant, table(island, native)) #have all combinations here. 
#if samples are unequal, can't use anova(model)
##good = balanced, fine = unequal sample sizes, ugly = one or more combination is missing

#check across sites: 
with(transplant, ftable(island, native, site))
#well, we only sampled at 2 sites on Guam, and three sites on Saipan, and we don't have all levels of native for all sites. Need to be careful about how we use site in the model. 

#summary
# no obvious outliers
# can go ahead looking at web size relative to island and native. 
# there is a lot of variability - is there something I might have measured related to web size that is not the thing I'm testing? 

#################################################
# Fix up dataframe
# a.	Remove missing values (NA’s)


# b. Standardize continuous predictors (if necessary)
### Why?? You would center (standardize) continuous covariates to remove correlation between slope and intercept. Centering is just putting each value around the mean, whereas standardizing is dividing by SD too. Standardizing puts all variables on the same scale (e.g. temperature, pH etc.), which can be useful for comparing effect sizes of variables, and it can help with model convergence. May be necessary with small datasets with lots of covariates, especially. 
# #in this situation, not necessary, bc no continuous predictors


