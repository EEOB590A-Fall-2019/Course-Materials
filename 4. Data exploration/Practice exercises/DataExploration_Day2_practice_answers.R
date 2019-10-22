#Data Exploration and visualization practice exercise
#EEOB590A

#Research Question: 
#does survival of seedlings depend on distance from nearest conspecific adult

library(ggplot2)
library(skimr)
library(tidyverse)
library(DataExplorer)

######### Get Dataset Prepared for Exploration ##################

#1) start with a tidy dataset
fencesurv <- read.csv("data/tidy/fencesurv_tidy.csv", header=T, na.strings=c("", "NA", "na")) 

#############################################
#data dictionary
# "species"- six plant species     
# "disp" - disperser present on island - yes/no          
# "island" - island (guam, saipan, tinian, rota)     
# "site"    - 5 sites on Guam, 3 each on Rota, Tinian, Saipan         
# "fence"   - fence name (based on forest plot grid names)       
# "numalive"  - number seedlings alive in fence 
# "date"       - date fence checked     
# "observer"   - person collecting data      
# "dataentry"   - person entering data     
# "dateenter"    - date data entered    
# "uniqueidsppfence" - unique id for each spp:fence combo
# "canopydate"    - date canopy cover data taken 
# "north"          - canopy measurement 1  
# "east"           - canopy measurement 2     
# "south"            - canopy measurement 3  
# "west"             - canopy measurement 4   
# "avgcover"        -average canopy measurement (% cover)    
# "avgopen"          -average canopy measurement (% open)   
# "doubleplant"     - was this fence double planted? 
# "plantdt"          - planting data
# "dist"             - near or far from conspecific? 
# "soil"             - soil type within the fence
# "numseedplant"    - number of seedlings planted
# "DDsurvival_notes"  - notes
# "bird"             - bird presence or absence on the island
# "age"             - age of seedlings (since planting)
# "centavgopen"      - centered average open
# "adultdens_wdisp"  - adult tree density on islands with disperser for that spp
# "adultdens_wodisp" - adult tree density on islands without disperser for that spp
# "seedsize"       - seed size 
# "numtrees"        - number of conspecific trees in the plot 
# "area"            - area of the plot
# "dens_100m"       - calculated density per 100 m
# "regdens"         - density across all plots
# "regdenswd"       - density just from plots with dispersers for that species
# 
#############################################

#2) check structure to make sure everything is in correct class
str(fencesurv)
summary(fencesurv)

#3) Subset to the dataset you will use for the analysis
#we will use the whole dataset for now, may subset & re-run later. 

#a) Make a new column for propalive by dividing numalive/numseedplant 
fencesurv <- fencesurv %>%
  mutate(propalive = numalive/numseedplant)

#4) Decide which variables are your response variables and which are your predictors
# Response: cbind(numalive, numseedplant) or propalive
# Continuous predictors: distance, centavgopen
# Categorical predictors: species
# Random effects: island (n=4 usually), site (n=3/island)

############ Start Data Exploration ##########
#1) try the skim() functions from the skimr package and the create_report() function from DataExplorer package. Note anything that stands out to you from those. 
skim(fencesurv)
create_report(fencesurv)

########## INDIVIDUAL VARIABLES #####################
#2) Start with your continuous variables. 
# a) With your continuous response and predictor variables, use ggplot and geom_histogram or dotchart() to look for outliers. 

ggplot(fencesurv, aes(propalive))+
  geom_histogram()

ggplot(fencesurv, aes(centavgopen))+
  geom_histogram()

dotchart(fencesurv$propalive) #no outliers
dotchart(fencesurv$centavgopen) #two outliers, both at far distances and both on Guam - maybe should remove?

# b) With your continuous response variable, look for zero-inflation (count data only). Are there more than 25% zero's in the response? 

sum(fencesurv$numalive/fencesurv$numseedplant== 0) / length(fencesurv$numalive/fencesurv$numseedplant) #17% zeros

papaya<-fencesurv %>%
  filter (species=="papaya")

sum(papaya$numalive/papaya$numseedplant== 0) / length(papaya$numalive/papaya$numseedplant) #57% zeros. 

with(papaya[papaya$numalive>0,], table(island, dist)) #some alive at each distance on each island, except Saipan far (why is this??)  # check raw data

# c) With your continuous response variable, look for independence. 
# Are there patterns in the data that are unrelated to the fixed or random effects identified above?  Consider patterns over time, for example. 


# 3) Now, explore your categorical predictors
# a) assess whether you have adequate sample size. How many observations per level of each of your categorical predictors? Are there any that have fewer than 15 observations?  

########## RELATIONSHIPS BETWEEN VARIABLES #######################
# 4) Explore relationships between your predictor variables
# a) look for correlation/covariation between each of your predictors (fixed & random)
#If 2 continuous predictors, use ggplot, geom_point to plot against each other, or use pairs()
#If 1 continuous and 1 categorical predictor, use ggplot with geom_boxplot() 
#For two categorical predictors, use summarize or table (ftable for more than 2 categories)

MyVar <- c("species", "dist", "centavgopen", "soil", "site", "island")
pairs(fencesurv[,MyVar])


# b) Interactions: need to make sure you have adequate data for any 2-way or 3-way interactions in your model. 
## We are interested in a species * distance * centavgopen interaction. Do we have adequate sampling across this interaction? 
mytable<-with(fencesurv, table (species, island, dist, soil)) 
with(fencesurv, ftable(species, dist, island))

numsamp<- fencesurv %>%
  group_by(island, species, soil) %>%
  summarize(count=length(soil))

ggplot(numsamp, aes(soil, count))+
  geom_boxplot()+
  facet_grid(species~island)+
  theme_bw() #some uneven samples - e.g. lots mix on Guam, whereas more soil on Rota and Saipan. 

#check to see which spp we are missing soil or openness data for
fencesurvNA <- fencesurv %>%
  filter(is.na(centavgopen) | is.na(soil)) 

summary(fencesurvNA) #mostly papaya, some morinda; lots on tinian missing openness data


#openness relative to distance
ggplot(fencesurv, aes(dist, centavgopen))+
  geom_boxplot() #two outliers for openness are at far distances, maybe remove?

ggplot(fencesurv, aes(soil, centavgopen))+
  geom_boxplot()+
  ylim(0,40) #centavgopen is similar for all soil types

ggplot(fencesurv, aes(species, centavgopen))+
  geom_boxplot()+
  ylim(0,40) #some variation in centavgopen between spp, but not too much. 

ggplot(fencesurv, aes(island, centavgopen))+
  geom_boxplot()+
  ylim(0,40) #guam and tinian similar, rota, saipan slightly lower. Guam has more outliers at upper openness levels. 

ggplot(fencesurv, aes(site, centavgopen))+
  geom_boxplot()+
  #  ylim(0,40) +
  facet_grid(.~island) #lot of heterogeneity, but nothing seems consistent between islands- just site to site differences. #openness data missing for tinian. 

# 5) Look at relationships of Y vs X’s to see if variances are similar for each X value, identify the type of relationship (linear, log, etc.)
#plot each predictor and random effect against the response
ggplot(fencesurv, aes(dist, numalive/numseedplant))+
  geom_boxplot()+
  facet_grid(soil~species) #some soil data missing for morinda, papaya, aglaia(?)

ggplot(fencesurv, aes(dist, numalive/numseedplant))+
  geom_boxplot()+
  facet_grid(.~species) #many papaya are dead.Few aglaia, neiso, psychotria are dead.  
ggplot(fencesurv[fencesurv$centavgopen<35,], aes(centavgopen, numalive/numseedplant))+
  geom_point()+
  facet_grid(soil~species) #very few canopy open data points beyond 30. Could consider truncating at 35 to remove influential points
#potentially nonlinear (saturating) relationship between openness and prop survival

ggplot(fencesurv, aes(centavgopen, numalive/numseedplant))+
  geom_point()+
  facet_grid(dist~species) 

ggplot(fencesurv, aes(island, numalive/numseedplant))+
  geom_boxplot()+
  facet_grid(dist~species) #lot of island differences

ggplot(fencesurv, aes(site, numalive/numseedplant))+
  geom_boxplot()+
  facet_grid(dist~species) #lot of site differences

############
#Summary of data exploration

####### 1: Individual variables ########
#a) Continuous variables (propalive, canopy)

#### Outliers (response & predictors)
#No outliers in response. Some NA's in response- will need to clean this up. 
#Some outliers in canopy (high values)- both are far and on Guam. Should remove from analysis. 

#### Zero-inflation (response)
# 17% zeros. this is distributed unevenly across spp, though, with 56% zeros for papaya.Keep an eye on papaya- low sample size. 

#### Independence (response)
# random effects of site and island warranted. Note- 4 levels of island, 3-5 levels of site within island so many would question this as a random effect because not enough levels. Also, not all spp planted on all islands. 
# temporal correlation: all samples taken at same time, but could look at effect of age of seedlings on prop survival
# I don't think there would be spatial correlation beyond site, but could examine response against latitude. 

#b) Categorical predictors and Random effects (island, soil, species)
# Low numbers of papaya 
# missing soil data for a significant number of plants. 

####### 2: Multiple  variables ########
#a: Predictor vs predictor

#### Collinearity: No strong collinearities. Heterogeneity, though. 

#### Interactions - do we have enough data? 
#species * soil: many papaya are lacking soil data. 
#soil*species*island: missing data on some of these intearctions 
#island * species: No neiso planted on Rota, no Psychotria planted on Tinian

#b: Predictor vs response: 
#### Linearity & homogeneity- relationship of Y vs X's. 
# potential nonlinear relationship between centavgopen and propsurvival (saturating?) but maybe the link function will take care of this? 
# heterogeneity in a variety of response factors. 


#############################################
#remove two extreme datapoints with really high canopy open values because they are only on Guam and at far distances - have undue influence
fencesurv<-fencesurv[is.na(fencesurv$centavgopen) | fencesurv$centavgopen<35,] #lost two points (both guam and far)

#########################################
# Make dataset without NA's in avgopen
fencesurvnoNA<-subset(fencesurv, !is.na(centavgopen)) #dataset without na's in open
dim(fencesurvnoNA) #lost fences by removing data with na's in open -mostly japc data
