library(caret)
library(randomForest)
library(rminer)
library(TTR)
library(gbm)


### Load data
data.csp.source <- read.csv('data/A03T.preprocessed.csv', header=T, sep=",")

### Correct data
#

### Filtrate data
#

### Test and training set
source('preprocess/split.dataframe.R')
data.csp = split.dataframe(data.csp.source)
idx = grep('c', colnames(data.csp$train))
#data.csp$train[, idx] = factor(data.csp$train[, idx])
#data.csp$test[, idx]  = factor(data.csp$test[, idx])

### GLM
source("models/glm.R")
glm = glm.model(data.csp$train[, idx], data.csp$test[, idx],
                data.csp$train[, -idx], data.csp$test[, -idx])

### Random forest
source("models/rand.forest.R")
rf <- rand.forest(data.csp$train[, idx], data.csp$test[, idx],
                  data.csp$train[, -idx], data.csp$test[, -idx],
                  Ntree=1000)

### Gradient boosting for angle and axis
#source("models/grad.boost.R")
#gb <- grad.boost(tmp.emg, tmp.angle, tmp.axis, training.set, 
#                 test.set, Ntree = 1000, depth = 4)
#print(gb)

### Visualization
#source("visualization.R")
print(glm$cm$table)
image(glm$cm$table)

print(rf$cm$table)
image(rf$cm$table)

### Save workspase
#save.image("emg.RData")