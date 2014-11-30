addpath('./classifyer', ...
        './data', ...
        './extract_features', ...
        './preprocess', ...
        './read')

filenames = ['A03T'; 'A04T'; 'A05T'; 'A06T'];

write_preprocessed_to_file = 0;
write_features_to_file = 1;

num = 1;
filename = filenames(num,:);

[data, n] = read_data([filename, '.gdf']);

%Preprpcess arguments: 1, 2 - data. 
% 3 - number of measurments to cut.
% 4 - Name of output file
% 5 - write to file (1) or not (0)
% 6 - extract trials (1) or not (0) - cut only those parts of signal,
% that refer to motor imagery.
preprocessed_data = preprocess(data, n, 313, [filename, '.csv'], 0, 1);
feature_matrix = extract_features(preprocessed_data);


if write_features_to_file
	dlmwrite(['./data/', filename, '.preprocessed.csv'], feature_matrix, ',');
end
