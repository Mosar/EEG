library(caret)
library(e1071)

glm.model <- function(data.train.class, data.test.class,
                      data.train.features, data.test.features){
        
    glm.class <- glm(data.train.class ~ ., 
                     data = data.train.features)
    glm.class.predict = predict(glm.class, data.test.features)
    
    glm.class.predict = round(glm.class.predict)
    glm.class.predict[which(glm.class.predict < 1)] = 1
    glm.class.predict[which(glm.class.predict > 4)] = 4
    
    glm.cm = confusionMatrix(data=glm.class.predict, reference=data.test.class,
                             positive = NULL, dnn = c("Prediction", "Reference"))
    
    return( list(cm = glm.cm) )
}