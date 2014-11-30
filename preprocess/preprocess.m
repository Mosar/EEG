function preprocessed_data = preprocess(raw_data, n, to_cut_steps, output_name, save_to_file, extract_trials)
    %[raw,n] = read_data('A03T.GDF');
    %Example : preprocessed_data = preprocess_data(raw, n, 0, 'A03T.csv', 1); 
    %

    labels = [n.EVENT.TYP, n.EVENT.POS, n.EVENT.DUR];
 
    class = zeros(size(raw_data(:,1)));
    
    %for i = 1: size(labels(:,1))
    %    if n.EVENT.TYP(i) == 769 | n.EVENT.TYP(i) == 770 | n.EVENT.TYP(i) == 771 | n.EVENT.TYP(i) == 772
    %        %class((n.EVENT.POS(i)+to_cut_steps):(n.EVENT.POS(i)+n.EVENT.DUR(i))) = ones(n.EVENT.DUR(i)+1 - to_cut_steps, 1).*(772+1-n.EVENT.TYP(i));
    %        class((n.EVENT.POS(i)+to_cut_steps):(n.EVENT.POS(i)+n.EVENT.DUR(i) - 1)) = ones(n.EVENT.DUR(i) - to_cut_steps, 1).*(772+1-n.EVENT.TYP(i));
    %    end
    %end   
    
    duration = 313 + 500;
    for i = 1: size(labels(:,1))
        if n.EVENT.TYP(i) == 769 | n.EVENT.TYP(i) == 770 | n.EVENT.TYP(i) == 771 | n.EVENT.TYP(i) == 772
            %class((n.EVENT.POS(i)+to_cut_steps):(n.EVENT.POS(i)+n.EVENT.DUR(i))) = ones(n.EVENT.DUR(i)+1 - to_cut_steps, 1).*(772+1-n.EVENT.TYP(i));
            class((n.EVENT.POS(i)+to_cut_steps):(n.EVENT.POS(i)+duration - 1)) = ones(duration - to_cut_steps, 1).*(772+1-n.EVENT.TYP(i));
        end
    end   
    
    
    %preprocessed_data = [raw_data, class];
    preprocessed_data = raw_data;
    
    %bandpower_data = bandpower(preprocessed_data(:,1:25), 250, [12, 16], 1, 4);
    bandpower_data = bandpower(preprocessed_data(:,1:25), 250, [8, 12], 1, 4);
    
    preprocessed_data = [bandpower_data, class];
   
    if extract_trials
        preprocessed_data = preprocessed_data(preprocessed_data(:, 26) ~= 0, :);
    
    if save_to_file
        dlmwrite(['./data/', output_name], preprocessed_data, ',');
    end
end