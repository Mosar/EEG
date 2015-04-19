%%
clear all;
clc;

%% Configuration
config = struct;
% config.method = 'Common Spatial Pattern';
% config.method = 'Deep Belief Network';
config.method = 'Deep Belief CSP';

%% Initialization
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

%% Proceed
switch config.method
    case 'Common Spatial Pattern'
        % Number of counts from the beginning to be cut 
        config.preproc.cnts_to_cut    = 313;
        % Name of output file
        config.preproc.write_to_file  = true;
        config.preproc.filename       = [filename, '.csv'];
        % Extract only labeled data (what refer to motor imaginary)
        config.preproc.extract_trials = true;
        
        [preprocessed_data, trials_left] = preprocess(data, n, config.preproc);

        % Extract features arguments
        % 1 - data
        % 2 - trial size, 500 default
        % 3 - #of trials

        feature_matrix = extract_features(preprocessed_data, 500, trials_left);

    case 'Deep Belief CSP'

        % Number of counts from the beginning to be cut 
        config.preproc.cnts_to_cut    = 313;
        % Name of output file
        config.preproc.write_to_file  = true;
        config.preproc.filename       = [filename, '.csv'];
        % Extract only labeled data (what refer to motor imaginary)
        config.preproc.extract_trials = true;
        
        [preprocessed_data, trials_left] = preprocess(data, n, config.preproc);

        % Extract features arguments
        % 1 - data
        % 2 - trial size, 500 default
        % 3 - #of trials

        feature_matrix = extract_features(preprocessed_data, 500, trials_left);
        
        X = feature_matrix(:, 1:6);
        Y = feature_matrix(:, 7);
        
        y_onehot = zeros(numel(Y), 4);
        for i = 1:numel(Y)
            y_onehot(i, Y(i)) = 1;
        end
        Y = y_onehot;
        
        [trainInd, valInd, testInd] = dividerand(size(X, 1), 0.8, 0.2, 0.0);
        test_x  = X(valInd, :);
        test_y  = Y(valInd, :);
        train_x = X(trainInd, :);
        train_x = train_x - min(train_x(:));
        train_x = train_x / max(train_x(:));
        train_y = Y(trainInd, :);

        %% --- Train a DBN and use its weights to initialize a NN
        rand('state',0);
        dbn  = struct;
        nn   = struct;
        opts = struct;
        
        %% Train DBN
        %dbn.sizes = [50 50 50 50 50 50];
        dbn.sizes = [20];
        opts.numepochs =  100;
        opts.batchsize =  27;
        opts.momentum  =  0.01;
%         opts.alpha     =  1;
        opts.alpha     =  0.05;
        dbn = dbnsetup(dbn, train_x, opts);
        dbn = dbntrain(dbn, train_x, opts);

        %% Unfold DBN to NN
        nn = dbnunfoldtonn(dbn, 4);
        nn.activation_function = 'sigm';

        %% Train NN
        opts.numepochs =  100;
        opts.batchsize = 27;
        nn = nntrain(nn, train_x, train_y, opts);

        %% Check results on test set
        test_y_idxs = zeros(size(test_y, 1), 1);
        for idx_row = 1:size(test_y, 1)
            test_y_idxs(idx_row) = find(test_y(idx_row, :));
        end
        
        tmp_y = nnpredict(nn, test_x);
        confusionmat(test_y_idxs, tmp_y)
        
        %% Check result on train set
        train_y_idxs = zeros(size(train_y, 1), 1);
        for idx_row = 1:size(train_y, 1)
            train_y_idxs(idx_row) = find(train_y(idx_row, :));
        end

        tmp_y = nnpredict(nn, train_x);
        confusionmat(train_y_idxs, tmp_y)
        
    case 'Deep Belief Network'
        [X, Y] = preprocess_deep(data, n, 313, true, [filename, '.csv'], false, true);

        [trainInd, valInd, testInd] = dividerand(size(X, 1), 0.8, 0.2, 0.0);
        test_x  = X(valInd, :);
        test_y  = Y(valInd, :);
        train_x = X(trainInd, :);
        train_x = train_x - min(train_x(:));
        train_x = train_x / max(train_x(:));
        train_y = Y(trainInd, :);

        %% --- Train a DBN and use its weights to initialize a NN
        rand('state',0);
        dbn  = struct;
        nn   = struct;
        opts = struct;
        
        %% Train DBN
        dbn.sizes = [50 50 50 50];
        opts.numepochs =  100;
        opts.batchsize =  27;
        opts.momentum  =  0.1;
%         opts.alpha     =  1;
        opts.alpha     =  0.5;
        dbn = dbnsetup(dbn, train_x, opts);
        dbn = dbntrain(dbn, train_x, opts);

        %% Unfold DBN to NN
        nn = dbnunfoldtonn(dbn, 4);
        nn.activation_function = 'sigm';

        %% Train NN
        opts.numepochs =  50;
        opts.batchsize = 27;
        nn = nntrain(nn, train_x, train_y, opts);

        %% Check results on test set
        test_y_idxs = zeros(size(test_y, 1), 1);
        for idx_row = 1:size(test_y, 1)
            test_y_idxs(idx_row) = find(test_y(idx_row, :));
        end
        
        tmp_y = nnpredict(nn, test_x);
        confusionmat(test_y_idxs, tmp_y)
        
        %% Check result on train set
        train_y_idxs = zeros(size(train_y, 1), 1);
        for idx_row = 1:size(train_y, 1)
            train_y_idxs(idx_row) = find(train_y(idx_row, :));
        end

        tmp_y = nnpredict(nn, train_x);
        confusionmat(train_y_idxs, tmp_y)
        
end

%% Visualize results
0;

%% Store results
if write_features_to_file
	dlmwrite(['./data/', filename, '.preprocessed.csv'], feature_matrix, ',');
end
