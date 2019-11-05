###### Linear models - Spider Web Size Analysis ######

#Research Question: 
#1) Do spiders build smaller webs when birds are present? If so, then web size should be smaller on Saipan than on Guam. Does it depend on whether the web was transplanted or found in place (i.e. native)?
#Response: websize
#Predictors: island, native, island:native
#(optional) Random effect: site
#approach: Use a linear model without the random effect. I have added a linear mixed effects model (lmer) with the random effect for demonstration purposes. 

#2) Does the spider presence depend on island or netting or the interaction between the two?  

library(ggplot2)
library(emmeans) #for post-hoc test
library(tidyverse)
library(ggResidpanel)
library(car) #note, may need to install "openxlsx" package too and choosing "no" when they ask if you want to install from sources which need compilation. 

transplant<-read.csv("data/tidy/transplant_tidy_clean.csv", header=T)
nrow(transplant) #91 rows

###### Data Exploration ############
# Usually, I would like to see the data exploration in the same script as the analysis, but for demonstration purposes, I have separated them. 
#To see the Data Exploration step for this analysis, go to "DataExplorationDay2.R" in Section 4 of this class. 

#summary of data exploration
# no obvious outliers
# can more forward with analysis of web size relative to island and native. 
# there is a lot of variability in web sizes - should consider whether there is something I might or might not have measured related to web size aside from island/native that might affect web size.  

#################################################
# Fix up dataframe
# a.	Remove missing values (NA’s)
# #in this situation, not necessary bc no NA's in predictors or response.

# b. Standardize continuous predictors (if necessary)
# #in this situation, not necessary, bc no continuous predictors

##################################################
###########  Analysis   ###############

#1) Do spiders build smaller webs when birds are present? If so, then web size should be smaller on Saipan than on Guam. Does it depend on whether the web was transplanted or found in place (i.e. native)? 

#using all data
#websize~island*native, family=gaussian  #by default, an identity link

webmod1 <- lm(websize~island*native, transplant)
summary(webmod1)
anova(webmod1) #should avoid if unbalanced sample sizes

#note: a linear model is doing the same thing as an anova
webaovmod <- aov(websize~island*native, data=transplant)
summary(webaovmod)

#check out the design matrix
model.matrix(webmod1)

# There are many strategies for model selection, and much disagreement about which approach is best. 

# 1. Classical Hypothesis testing: drop all nonsignificant predictors, starting with interactions, then main effects. All predictors in final model will be significant. 

webmod1 <- lm(websize~island*native, data=transplant)
anova(webmod1) #should avoid if unbalanced sample sizes

#the island * native interaction is not significant, so run model with only main effects. 

webmod1a <- lm(websize ~ island + native, data = transplant) 
anova(webmod1a) #native main effect is not significant

#so final model would be: 
webmod_classic <- lm(websize ~ island, data=transplant)
anova(webmod_classic)

# anova(model) gives Type I sums of squares, which means the reference level is tested first and then other levels, and then interactions. R defaults to treatment contrasts, where first level is baseline, and all others are in reference to that. Can get different results for unbalanced datasets depending on which factor is entered first in the model and thus considered first. For information on Type II and III sums of squares, see the end of this script. 

# 2. If you do an experiment, don’t do any model selection at all- fit model that you think makes sense, and keep everything as it is, even non-significant parameters. Some might choose to do some model selection to keep only significant interactions, but once fit model with main effect terms, then stick with it. 

webmod1 <- lm(websize ~ island*native, data=transplant)
summary(webmod1)

# 3. Classic model selection: Create all sub-models. Use LRT to come up with best model. 
webmod2<-lm(websize~island+native, data=transplant)
webmod3<-lm(websize~island, data=transplant)
webmod4<-lm(websize~native, data=transplant)
webmod_null<-lm(websize~1, data=transplant)

anova(webmod1, webmod2)  #model 1 not sig better than 2
anova(webmod2, webmod3)  #model 2 not sig better than 3
anova(webmod3, webmod4) #can't run this, because not sub-model - needs to be nested to compare with LRT
anova(webmod3, webmod_null) #model 3 sig better fit than null model
anova(webmod4, webmod_null)

# 4. Information theoretic approach- compare models using AIC- get competing models. AIC is a measure of the goodness of fit of an estimated statistical model. It is -2*log-likelihood + 2*npar, where npar is the number of effective parameters in the model. More complex models get penalized. 

AIC(webmod1, webmod2, webmod3, webmod4, webmod_null) #webmod3 has lowest AIC, by almost 2 points. Might consider model averaging. 

#check out packages MuMIn and AICcmodavg for a variety of useful tools. 


##### Model validation #########

#super important step -don't overlook! 

#A. Look at homogeneity: plot fitted values vs residuals
#B. Look at influential values: Cook
#C. Look at independence: 
#      plot residuals vs each covariate in the model
#      plot residuals vs each covariate not in the model
#      Common sense 
#D. Look at normality of residuals: histogram

#for lm can use plot(model), but this doesn't work for glm & glmer
plot(webmod1)

#even better, use ggResidpanel
resid_panel(webmod1)
resid_compare(list(webmod1, webmod_classic)) #to compare two models
resid_xpanel(webmod1) #to plot residuals against predictor variables

###### Code to run fitted and residuals by hand ####3
#extract residuals
E1 <- resid(webmod1, type = "pearson")

#plot fitted vs residuals
F1 <- fitted(webmod1, type = "response")

par(mfrow = c(2,2), mar = c(5,5,2,2))
plot(x = F1, 
     y = E1, 
     xlab = "Fitted values",
     ylab = "Pearson residuals", 
     cex.lab = 1.5)
abline(h = 0, lty = 2)

#### Hypothesis testing ##############
#You have your model. How do you interpret the results? 

#Option 1: If you have only continuous predictors, or 

#Option 2: If you have multiple levels of a factor, will need a post-hoc test to assess differences between levels of the factor. There are several options, but emmeans is a good one. 
webmod1_classic <- lm(websize~island, data=transplant)
anova(webmod1)

isl <- pairs(emmeans(webmod1_classic, ~island)) # to test whether there are differences between guam & saipan given a particular native status
isl #shows p-value;compare to
summary(webmod1_classic)

#can use emmeans to test for main effects when there is an interaction present. 
natisl <- pairs(emmeans(webmod1, ~native | island)) #to test whether there are differences between native & not native given that you are on Guam or Saipan
natisl

#Option 2: confidence intervals
confint(webmod1) #Intercept is guam, with transplanted spiders. Only the intercept has confidence intervals that do not cross zero, so no difference using this approach. 


### LMER ########
#in this model, we have added a random effect of site

library(lme4)
webmod_mm<-lmer(websize ~ island+native + (1|site), data=transplant)
summary(webmod_mm) #no p-values! 

#explore model fit 
resid_panel(webmod_mm)
resid_xpanel(webmod_mm)

#a small amount of heterogeneity in residuals bt islands
#a small amount of heterogeneity in residuals wrt native
#residual variance slightly larger at Guam sites than Saipan sites, but homogeneity bt sites within an island

### GLM #######

#need to change spidpres to 1's and 0's

transplant$spidpresbin <- ifelse(transplant$spidpres == "yes",1 ,0)

transplant %>%
        count(spidpresbin)

spidmod <- glm(spidpresbin ~ island+native, family = binomial, data=transplant)
summary(spidmod) 

resid_panel(spidmod)
resid_xpanel(spidmod) #need to fix this. 

### Sums of Squares and contrasts  ################

##can use car package to do Type II or III sums of squares
Anova(webmod1, type="III") #Type III tests for the presence of a main effect after the other main effect and interaction. This approach is therefore valid in the presence of significant interactions.However, it is often not interesting to interpret a main effect if interactions are present (generally speaking, if a significant interaction is present, the main effects should not be further analysed).

#explore contrasts
options('contrasts') #shows what contrasts R is using

#can set contrasts to SAS default. "contr.SAS" is a trivial modification of contr.treatment that sets the base level to be the last level instead of the first level. The coefficients produced when using these contrasts should be equivalent to those produced by SAS.

webmod1a<-lm(websize~island*native, data=transplant, contrasts = list(island = "contr.SAS", native="contr.SAS"))
summary(webmod1a)

#Type II
Anova(lm(websize~island+native, data=transplant), type="II")  #This type tests for each main effect after the other main effect.Note that Type II does not handle interactions.

#compare against 
anova(lm(websize~native+island, data=transplant))
anova(lm(websize~island+native, data=transplant))
