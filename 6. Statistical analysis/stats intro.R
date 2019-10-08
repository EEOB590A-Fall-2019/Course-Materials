#EBIO 323 Statistics

# Resources
#http://egret.psychol.cam.ac.uk/statistics/R/basicstats.html
#http://www.statmethods.net/stats/frequencies.html
#https://www.zoology.ubc.ca/~schluter/R/fit-model/

######## Standard Deviation Example From Class ########
se <- function(x) sqrt(var(x)/length(x))
A<-as.numeric(c(13, 15, 15, 16, 15, 10))
B<-as.numeric(c(18, 10, 13, 19, 9, 15))
mean(A)
mean(B)
var(A)
var(B)
sd(A)
sd(B)
se(A)
se(B)

######## Work with Spider dataset ###############
#first, set working directory using files tab on the lower right side of R Studio. 
#1. Navigate to the folder with your data. (use ... button on right side)
#2. select "more". 
#3. Select "set as working directory"

#Next, load dataset. 
spider<-read.csv("spider.csv", header=T)

#attach data (optional)
attach(spider)

####Check class of data ####
str(spider)

############Summary statistics
mean(tot_webs,na.rm=T)
median(tot_webs, na.rm=T)
fivenum(tot_webs, na.rm=T) # Tukey's five number summary (minimum, lower-hinge, median, upper-hinge, maximum)
summary(tot_webs, na.rm=T) # Summarizes model fits, and simple data (for which it gives minimum, first quartile, median, mean, third quartile, maximum).
min(tot_webs, na.rm=T)
max(tot_webs, na.rm=T)
quantile(tot_webs, na.rm=T) # calculates any quantile (not just the default of 0%, 25%, 50%, 75%, 100%)
var(tot_webs, na.rm=T) # sample variance
sd(tot_webs, na.rm=T) # sample standard deviation

########### Counts, boxplots, histograms etc.- use to examine data ##########
table(island, tot_webs) # shows counts of each value in x (producing a unidimensional list of frequencies with the values as dimnames)
table(tot_webs)/length(tot_webs) # shows relative frequencies
barplot(table(tot_webs)) # by virtue of the way table() produces its results, this produces a frequency histogram
hist(tot_webs) # a more general way of doing a histogram (also deals with continuous data).
# Use "prob=TRUE" to plot relative frequencies (so the area under the graph is 1).
# The "breaks" option can be used for manual control of the number of bins.
boxplot(tot_webs) # Box-and-whisker plot
boxplot(tot_webs~island) #boxplot separated by group
plot(birddens, tot_webs) #scatterplot, but bird_dens varies by island and only 4 islands, so it looks strange

##########################################
## Analyses ##
##########################################

####Correlation test ########
birdcor<-cor.test(birddens, tot_webs) #Is bird density correlated with the total number of webs? 
birdcor

####linear regression#########
test<-lm(tot_webs~birddens) #does birddensity predict the number of webs? 
summary(test) #show results
anova(test) # to test for significance
plot(test) #look at residuals (fitted vs residuals shouldn't have any pattern to it, Q-Q plot should be along 1:1 line)
plot(birddens, tot_webs) #scatterplot, but bird_dens varies by island and only 4 islands, so it looks strange
abline(test) #add a line showing the model prediction

###### Multiple Linear Regression Example
#test1 <- lm(y ~ x1 + x2 + x3) #sample code- we do not have variables named y, x1, x2, or x3
test1<-lm(tot_webs~birddens+length)
summary(test1) # show results
anova(test1) # to test for significance
plot(test1)

###t-test######## (is preferable to use lm instead of t-test for this in most cases)
#t.test(y~x)  #sample code- note that you can only have two levels of x in a t-test
#t.test(y1, y2) #where both y1 and y2 are numeric and you want to see if y1 differs from y2
#t.test(y1,y2, paired=TRUE) #both y1 and y2 are numeric and are paired
ttest1<-t.test(tot_webs~bird) #does bird presence affect the total number of webs? 
ttest1

#######Anova########
# One Way Anova (Completely Randomized Design); compare means of two or more samples (if two samples, could use ttest)
#fit <- aov(y ~ A) # sample code, 
model1<-aov(tot_webs~island)
summary(model1)
plot(model1)
#note- you can use a lm instead of aov for this: 
model2<-lm(tot_webs~island)
summary(model2)
anova(model2)
plot(model2)

#### Multiple factor Anova #######
model3<-aov(tot_webs~island+length)
summary(model3)
plot(model3)
#note- you can use a lm instead of aov for this: 
model4<-lm(tot_webs~island+length)
summary(model4)
anova(model4)
plot(model4)

# Randomized Block Design (B is the blocking factor)
#fit <- aov(y ~ A + B) # A and B are both factors

# Analysis of Covariance
#fit <- aov(y ~ A + x) #A is a factor and x is numeric

#####Chi-squared#########
#create your dataset
freqs <- c(12,12,13,18,17,12)
herbexp <- matrix(freqs, nrow=2)
dimnames(herbexp) <- list("treatment"=c("herbicide","water"), "outcome"=c("shrink","same","grow"))

#look at data
herbexp

#run chi-squared test
herbres<-chisq.test(herbexp) 
herbres$expected #expected counts under the null
herbres$observed

#### Logistic regression (for survival or proportion data) #########
inv<-read.csv("inv_logistic.csv", header=T)
detach(spider)
attach(inv)
str(inv)
summary(inv)
with(inv, table(invstatus, pH))
plot(pH, invstatus)

invmod<-glm(invstatus~pH, family=binomial, data=inv) #run glm
summary(invmod) #results of the model
#Here, and with all glm's, use anova(modelname, test="Chi") to get p-value rather than summary(modelname).
anova(invmod, test="Chi")
plot(pH, invstatus) #graph data
predicted<-fitted(invmod) #get model predictions for each pH
lines(pH[order(pH)], predicted[order(pH)]) #draw fitted line

######graphing with ggplot2########
#http://blog.echen.me/2012/01/17/quick-introduction-to-ggplot2/

library(ggplot2) #gives qplot and ggplot functions for graphing. 

qplot(island, geom="bar",
      xlab="island", ylab="Number of webs", 
      main="Spider webs by island")

ggplot(spider, aes(x=island, y=tot_webs))+
      geom_boxplot()+
      xlab("Island")+
      ylab("Number of webs")+ 
      ggtitle("Spider webs and Island")

# `Orange` is another built-in data frame that describes the growth of orange trees.
str(Orange)
summary(Orange)

qplot(age, circumference, data = Orange, geom = "line",
      colour = Tree,
      main = "How does orange tree circumference vary with age?")

# We can also plot both points and lines.
qplot(age, circumference, data = Orange, geom = c("point", "line"), colour = Tree)

#To show variability, use ggplot
ggplot(Orange, aes(x=age, y=circumference))+
  geom_point()+
  geom_smooth(method = "lm", formula = y ~ x)
