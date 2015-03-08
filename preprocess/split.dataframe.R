split.dataframe <- function(dataframe, seed=NULL) {
    if (!is.null(seed)) set.seed(seed)
    index <- 1:nrow(dataframe)
    trainindex <- sample(index, trunc(length(index)/2))
    trainset <- dataframe[trainindex, ]
    testset <- dataframe[-trainindex, ]
    list(train=trainset, test=testset)
}