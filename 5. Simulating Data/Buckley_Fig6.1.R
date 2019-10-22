# Normal data vs. normal errors
# Yvonne Buckley 03 July 2014
# script for reproducing Fig. 6.1 
# No input files
# No output files (figures are produced within R session)

# Note that the random numbers are different each 
# time so your fig will look different, run it a few times to see how different 
# sets of random numbers look. change the sample size to see how assessment of 
# normality holds up at lower sample sizes (hint: can be very difficult to assess
# at low sample sizes)

min_size<-0.01; max_size=3
int<-0
slope<-5
# choose 100 random numbers between min and max sizes
x_sim<-runif(50,min_size,max_size)

# generate simulated y-values from the Normal distribution,
# with a mean equal to the fitted relationship
# and a  constant standard deviation
# the sd does not change with the fitted values, it is constant.
# The errors of this relationship will be normally distributed,
# with constant variance and with a mean=0
y_sim_norm<-rnorm(length(x_sim), int + slope * x_sim, sd=1.5)
y_sim_norm <- rpois(length(x_sim), int + slope * x_sim)

lm_norm<-lm(y_sim_norm~x_sim)
summary(lm_norm)
# linear model of the y data based on the explanatory x data

y_errs_norm<-residuals(lm_norm)
# the errors are the residuals from the linear model

par(mfrow=c(2,2))
hist(y_sim_norm, freq=F, main="(a) Data", xlab="", col="lightgrey")
hist(y_errs_norm, freq=F, main="(b) Errors", xlab="", col="lightgrey")
qqnorm(y_sim_norm, main="(c) Normal Q-Q plot: y data"); qqline(y_sim_norm)
qqnorm(y_errs_norm, main="(d) Normal Q-Q plot: errors"); qqline(y_errs_norm)
# See Fig. 6.1