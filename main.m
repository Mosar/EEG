[data, n] = read_data('A03T.GDF');

%Preprpcess arguments: 1, 2 - data. 
% 3 - number of measurments to cut.
% 4 - Name of output file
% 5 - write to file (1) or not (0)
preprocessed_data = preprocess(data, n, 0, 'A03T.csv', 1);