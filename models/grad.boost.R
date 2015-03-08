### Gradient boosting for angle and axis
### Return RMSE for our prediction

#library(gbm)

grad.boost <- function(data.emg, data.angle, data.axis, training.set, test.set, Ntree, depth){
    data.emg.train <- as.data.frame( data.emg[training.set,])
    data.emg.test <- as.data.frame( data.emg[test.set,] )
    gbm.angle <- gbm(data.angle[training.set,1] ~ . , 
                    data = data.emg.train, n.trees = Ntree,
                     shrinkage = 10/Ntree, cv.folds = 5, verbose = TRUE,
                     interaction.depth = depth) 

    best.iter <- gbm.perf(gbm.angle, method="OOB")
    gbm.angle.predict <- predict(gbm.angle, data.emg.test, best.iter)
    RMSE.gbm.angle <- mmetric(y = data.angle[test.set,1], x = 
                               gbm.angle.predict, metric = 'RMSE')

    gbm.axis.predict <- matrix(NA, dim(data.emg.test)[1], 3)
    for (i in 1:dim(data.axis)[2]){
        gbm.axis <- gbm(data.axis[training.set,i] ~ . , 
                        data = data.emg.train, n.trees = Ntree,
                        shrinkage = 10/Ntree, cv.folds = 5, verbose = TRUE,
                        interaction.depth = depth) 
        gbm.axis.predict[,i] <- predict(gbm.axis, data.emg.test)
    }

    RMSE.gbm.axis <- sapply(1:3, function(i) {mmetric(y = data.axis[test.set,i], x = 
                                                         gbm.axis.predict[,i], metric = 'RMSE') } )

    #plot(gbm.angle.predict, data.angle[test.set,1])
    return( list(RMSE.gbm.angle = RMSE.gbm.angle, RMSE.gbm.axis = RMSE.gbm.axis) )
}