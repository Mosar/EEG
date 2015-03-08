### Return R-square for our prediction

rand.forest <- function(data.train.class, data.test.class,
                        data.train.features, data.test.features,
                        Ntree){
    
    ### Model
    rf.class <- randomForest(data.train.class ~ . , 
                             data=data.train.features, ntree = Ntree) 
    rf.class.predict <- predict(rf.class, data.test.features)
        
    ### Confusion matrix
    rf.cm = confusionMatrix(data=rf.class.predict, reference=data.test.class,
                            positive = NULL, dnn = c("Prediction", "Reference"))

    return( list(cm = rf.cm) )
}
