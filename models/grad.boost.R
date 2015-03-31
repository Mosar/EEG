### Gradient boosting
#library(gbm)
library(xgboost)

grad.boost <- function(data.train.class, data.test.class,
                       data.train.features, data.test.features,
                       Ntree, depth){
    
    gbm.class <- xgboost(data = as.matrix(data.train.features), 
                         label = as.matrix(data.train.class),
                         max.depth = 3, eta = 1, nround = 1000, 
                         objective = "binary:logistic")
        
#     gbm.class <- gbm(data.train.class ~ . , 
#                      data = data.train.features, n.trees = Ntree,
#                      shrinkage = 10/Ntree, cv.folds = 5, verbose = TRUE,
#                      interaction.depth = depth)
    
    gbm.class.predict <- predict(gbm.class, as.matrix(data.test.features))
#     gbm.class.predict <- predict(gbm.class, data.test.features, type='response')

#     gbm.class.predict = round(gbm.class.predict * 3) + 1
    print(gbm.class.predict)
    print(data.test.class)
    
    gbm.cm = confusionMatrix(data=gbm.class.predict, reference=data.test.class,
                             positive = NULL, dnn = c("Prediction", "Reference"))
    return( list(cm = gbm.cm) )
}