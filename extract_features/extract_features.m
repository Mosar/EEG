function feature_vector = extract_features(preprocessed_data)
    classColumn = 26;
    
    
    class1Matrix = preprocessed_data(preprocessed_data(:,26) == 1, 1:25);
    class2Matrix = preprocessed_data(preprocessed_data(:,26) == 2, 1:25);
    class3Matrix = preprocessed_data(preprocessed_data(:,26) == 3, 1:25);
    class4Matrix = preprocessed_data(preprocessed_data(:,26) == 4, 1:25);

    %     % BioSig CSP
    %     [V1_2, ~] = csp_fixed_biosig(class1Matrix, class2Matrix);
    
    [V1_2] = csp2type(class1Matrix', class2Matrix');
    [V1_3] = csp2type(class1Matrix', class3Matrix');
    [V1_4] = csp2type(class1Matrix', class4Matrix');
    [V2_3] = csp2type(class2Matrix', class3Matrix');
    [V2_4] = csp2type(class2Matrix', class4Matrix');
    [V3_4] = csp2type(class3Matrix', class4Matrix');
    
    VS = {V1_2; V1_3; V1_4; V2_3; V2_4; V3_4};
    
    % KOSTYL!!!
    stepSize = 500;
    trials = 288;
    % KOSTYL END
    
    feature_vector = [];
    
    for i = 0:(trials - 1)
        lower = stepSize*i + 1;
        upper = stepSize*(i+1);
        tmp = [];
        for t = 1 : numel(VS)
            V = VS{t};
            tmp = [tmp, norm(V*preprocessed_data(lower:upper, 1:25)')^2]; 
        end    
        tmp = [tmp, preprocessed_data(lower+1, 26)];
        
        feature_vector = [feature_vector; tmp];
             
    end
        
  end