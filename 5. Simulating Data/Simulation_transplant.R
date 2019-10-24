#Data simulation - spider transplant data

library(tidyverse)

transplant_tidy <- read.csv("data/tidy/transplant_tidy.csv")

#We need the following columns: 
  # response: websize or duration
  # predictors: island, site, netting

# We sampled two islands: Guam & Saipan. 
# Aimed for 3 sites on Saipan, 3 sites on Guam
# At each site, we aimed for 14 webs
# half of the webs with netting, half without
# total of 14*6 = 84 webs

with(transplant_tidy, ftable(island, site, netting))

#simulate response first
# we will treat websize as a normal distribution
# we predict that webs will be smaller on Saipan without a net 
gnetwebsize <- rnorm(n=21, mean=c(54), sd = c(10)) #simulate guam with net
gnonetwebsize <- rnorm(n=21, mean=c(54), sd = c(10)) #simulate guam without net
snetwebsize <- rnorm(n=21, mean=c(54), sd = c(10)) #simulate saipan with net
snonetwebsize <- rnorm(n=21, mean=c(49), sd = c(8)) #simulate saipan without net
response <- c(gnetwebsize, gnonetwebsize, snetwebsize, snonetwebsize)

gpois <- rpois(n=21, lambda=54)
gunif <- runif(n=21, 40, 64)
gbinom <- rbinom(n=21, size=1, .1)

#simulate predictors

island <- rep(c("guam", "saipan"), each = 42)
gsite <- factor(rep (c("a", "b", "c"), each = 7, times = 2))
ssite <- factor(rep (c("d", "e", "f"), each = 7, times = 2))
site <- c(gsite, ssite) #just need to use c() because both are vectors
netting <- rep (c("yes", "no"), each = 21, times = 2)

#combine all into a dataframe 
simtransplant <- data.frame(island, site, netting, response)
write.csv(simtransplant,"data/tidy/simtransplant.csv")

#look at response
ggplot(simtransplant, aes(island, response, fill=netting))+
  geom_boxplot()

#Run a model with dataset
m1<-lm(response~netting*island)
summary(m1)

#other helpful code: 
trtmt <- sample(c("Treated","Untreated"), size = 20, replace = TRUE)
ifelse(trtmt=="Treated", yes = rnorm(20, 10, 1), no = rnorm(20, 20, 1))
