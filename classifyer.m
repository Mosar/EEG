function trained_classifyer = train_classifyer(tr_set, class, classifyer_type)
    trained_classifyer = 0;
end

function class (classifyer, tst_set)
    class = classifyer.classify(tst_set)
end

