function [ preprocessed_deep, y ] = preprocess_deep (raw_data, n, to_cut_steps, output_name, save_to_file, extract_trials)
    
    labels = [n.EVENT.TYP, n.EVENT.POS, n.EVENT.DUR];

    duration = to_cut_steps + 500;
    
    artifact = false;
    
    trials_left = 0;
    

    usefulColumnsEnd = 22;    
    
    preprocessed_data = raw_data(:, 1:usefulColumnsEnd);

%    %bandpower_data = bandpower(preprocessed_data(:,1:25), 250, [12, 16], 1, 4);
%    bandpower_data = bandpower(preprocessed_data(:,1:usefulColumnsEnd), 250, [8, 12], 1, 4);
%    preprocessed_data = bandpower_data;
    
    preprocessed_deep = [];
    
    y = [];
    
    for i = 1: size(labels(:,1))
        if n.EVENT.TYP(i) == 1023
            artifact = true;
        end
        
        if n.EVENT.TYP(i) == 769 || n.EVENT.TYP(i) == 770 || n.EVENT.TYP(i) == 771 || n.EVENT.TYP(i) == 772
            if ~artifact
                trials_left = trials_left + 1;
                cur_example = preprocessed_data( (n.EVENT.POS(i)+to_cut_steps):(n.EVENT.POS(i)+duration - 1), : );
                cur_example = cur_example.';
                cur_example = cur_example(:);
                cur_example = cur_example.';
                cur_class = (772+1-n.EVENT.TYP(i));
                
                preprocessed_deep = [preprocessed_deep ; cur_example];
                y = [y ; cur_class];
                
            else
                artifact = false;
            end
        end
    end                                                                                                            
    
    %if extract_trials
    %    preprocessed_data = preprocessed_data(preprocessed_data(:, classColumn) ~= 0, :);
    %end 
    
    if save_to_file
        dlmwrite(['./data/', output_name], preprocessed_data, ',');
    end
    
end

