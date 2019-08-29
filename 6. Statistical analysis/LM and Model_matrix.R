#Learning about model matrices/design matrices

#create dataset
websize <- c(53, 49, 45, 60, 56, 48)
species <- c("A", "A", "B", "B", "C", "C")
island <- c("Guam", "Guam", "Guam","Saipan", "Saipan", "Saipan")
temp <- c(30, 35, 39, 30, 32, 27)

spidex <- cbind(websize, species, island, temp)

#Example 1: T-test

spidmod1 <- lm(websize ~ island)

model.matrix(spidmod1)

summary(spidmod1)

# Example 2: linear regression

spidmod2 <- lm(websize ~ temp)

model.matrix(spidmod2)

summary(spidmod2)

# Example 3: Anova

spidmod3 <- lm(websize ~ species)

model.matrix(spidmod3)

summary(spidmod3)

# Example 4: Two-way anova with interaction

spidmod4 <- lm(websize ~ island*species)

model.matrix(spidmod4)

summary(spidmod4)

# Example 5: linear mixed effects

library(lme4)

spidmod5 <- lmer(websize ~ island + (1|species))

model.matrix(spidmod5)

summary(spidmod5)
#compare to lm model
summary(spidmod1)
