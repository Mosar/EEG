function preprocessed_data = preprocess(raw_data, n, to_cut_steps, output_name, save_to_file)
    %[raw,n] = read_data('A03T.GDF');
    %Example : preprocessed_data = preprocess_data(raw, n, 0, 'A03T.csv', 1); 
    %

    labels = [n.EVENT.TYP, n.EVENT.POS, n.EVENT.DUR];
 
    class = zeros(size(raw_data(:,1)));
    
    for i = 1: size(labels(:,1))
        if n.EVENT.TYP(i) == 769 | n.EVENT.TYP(i) == 770 | n.EVENT.TYP(i) == 771 | n.EVENT.TYP(i) == 772
            class(n.EVENT.POS(i):(n.EVENT.POS(i)+n.EVENT.DUR(i))) = ones(n.EVENT.DUR(i)+1, 1).*(772+1-n.EVENT.TYP(i));
        end
    end   
    
    preprocessed_data = [raw_data, class];
    
    preprocessed_data = preprocessed_data(preprocessed_data(:, 26) ~= 0, :);
    
    
    if save_to_file
        dlmwrite(['./data/', output_name], raw_data, ',');
    end
end