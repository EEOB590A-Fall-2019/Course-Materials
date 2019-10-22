#create dataset based on a linear model
#this code is for Nicole Wackerly's dataset

npostures = 6
nrep = 10
b0 = 97
b1 = -2
b2 = 2
b3 = .001 
airtemp = runif(60, min=70, max=110)
sd = 2

posture = rep( c("pos1", "pos2", "pos3", "pos4", "pos5", "pos6"), each = nrep) 

eps = rnorm(npostures*nrep, 0, sd)

bodytemp = b0 + b1*(postures == "pos2") + b2*(postures == "pos3") + b3 *airtemp+ eps

chimps <- as.data.frame(cbind(posture, airtemp, bodytemp, eps))
