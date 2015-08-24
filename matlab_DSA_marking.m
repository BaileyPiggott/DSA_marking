

%% Import data from R of scores and text analysis
DSA_data = readtable('DSA_text.csv', 'ReadRowNames', 1, 'TreatAsEmpty', {'NA', 'na', 'N/A'});
DSA_scores = readtable('DSA_scores.csv', 'ReadRowNames', 1, 'TreatAsEmpty', {'NA', 'na', 'N/A'});

DSA_data = table2array(DSA_data); % convert to array for decision tree function
%DSA_data(isnan(DSA_data)) = 0; % replace NaN values with 0

DSA_scores = table2array(DSA_scores); % convert to array for decision tree function
%DSA_scores(isnan(DSA_scores)) = 0; % replace NaN values with 0

%% separate into training and testing data

training_set = DSA_data([4:10 4:10 4:10 4:10 4:10],:);
training_scores = DSA_scores([4:10 4:10 4:10 4:10 4:10],:);

test_set = DSA_data(1:4, :);
test_scores = DSA_scores(1:4, :);

%% single tree for problem definition score

pd_single_tree = fitctree(training_set, training_scores(:, 1)); % single classification tree
%view(pd_single_tree, 'mode', 'graph'); % view logic in a graph
pd_pred_single = predict(pd_single_tree, test_set);

%% bagged tree for problem definition score

pd_bagged_tree = TreeBagger(50,training_set, training_scores(:, 1));
pd_pred_bagged = predict(pd_bagged_tree, test_set); % predictions on test data

pd_pred_bagged = str2num(cell2mat(pd_pred_bagged)); % convert cell array of results to matrix of numbers

%% compare predicted problem definition scores

pd_results = [test_scores(:,1) pd_pred_single pd_pred_bagged];


%% conceptual design
% single tree

cd_single_tree = fitctree(training_set, training_scores(:, 2)); % single classification tree
%view(cd_single_tree, 'mode', 'graph'); % view logic in a graph
cd_pred_single = predict(cd_single_tree, test_set);

%bagged tree
cd_bagged_tree = TreeBagger(10,training_set, training_scores(:, 2));
cd_pred_bagged = predict(cd_bagged_tree, test_set); % predictions on test data

cd_pred_bagged = str2num(cell2mat(cd_pred_bagged)); % convert cell array of results to matrix of numbers

%results
cd_results = [test_scores(:,2) cd_pred_single cd_pred_bagged];




