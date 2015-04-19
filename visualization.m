filenames = ['A03T'; 'A04T'; 'A05T'; 'A06T'];

write_preprocessed_to_file = 0;
write_features_to_file = 1;

num = 1;
filename = filenames(num,:);

[data, n] = read_data([filename, '.gdf']);

config.preproc = struct;

% Number of counts from the beginning to be cut 
config.preproc.cnts_to_cut    = 313;
% Name of output file
config.preproc.write_to_file  = false;
config.preproc.filename       = [filename, '.csv'];

% Extract only labeled data (that refer to motor imaginary)
config.preproc.extract_trials = true;
        
[preprocessed_data, trials_left] = preprocess(data, n, config.preproc);

%Last column - class column
range = 90000:100000;

%Choose two channels:
c1 = 8;
c2 = 12;


figure();
title ('Channel activity ratio for different movements');

x = 1:size(preprocessed_data(range, c1));
y = preprocessed_data(range,c1)'./preprocessed_data(range,c2)';
z = zeros(size(x));

col = preprocessed_data(range, size(preprocessed_data,2))'; 

surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);

%hold();

%Adding data from the other channel
if 0
    x = 1:size(preprocessed_data(range,c2));
    y = preprocessed_data(range,c2)';
    z = zeros(size(x));

    col = preprocessed_data(range,size(preprocessed_data,2))';  

    surface([x;x],[y;y],[z;z],[col;col],...
            'facecol','no',...
            'edgecol','interp',...
            'linew',2);
end

[X, Y] = preprocess_deep(data, n, 313, true, [filename, '.csv'], false, true);
figure();
title ('Different chanels activity during trial');

%Create subplots
for i = 1:(size(X, 2) / 500)
    subplot(5, 5, i);
    for j = 1:size(X, 1)
        
        switch find(Y(j, :))
            case 1
                col = 'r';
            case 2
                col = 'g';
            case 3
                col = 'b';
            case 4
                col = 'y';
        end
%        plot(X(j,((i-1)*500+1):i*500), '.', 'Color', col);
        
        to_plot = X(j,((i-1)*500+1):i*500);
        x = 1:size(to_plot, 2);
        y = to_plot;
        z = zeros(size(x));
        %col = repmat(col, 1, size(x));
        surface([x;x],[y;y],[z;z] ,...
                'facecol','no',...
                'edgecol', col,...
                'linew',2, 'edgealpha', 0.1);


        hold on
    end
    hold off
end

