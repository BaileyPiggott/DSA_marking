
%% Import data from R of scores and text analysis
DSA_data = readtable('DSA_text.csv', 'ReadRowNames', 1, 'TreatAsEmpty', {'NA', 'na', 'N/A'});
DSA_scores = readtable('DSA_scores.csv', 'ReadRowNames', 1, 'TreatAsEmpty', {'NA', 'na', 'N/A'});

DSA_data = table2array(DSA_data); % convert to array for decision tree function
DSA_scores = table2array(DSA_scores); % convert to array for decision tree function

%% separate into training and testing data
training_set = DSA_data([5:10 5:10 5:10 5:10 5:10],:); % need at least 10 samples to grow trees
training_scores = DSA_scores([5:10 5:10 5:10 5:10 5:10],:);

test_set = DSA_data(1:4, :);
test_scores = DSA_scores(1:4, :);

n_bagged_trees = 25; % number of trees to grow for bagged decision tree

%% Predict Classifications
% using custom generateTrees function

% Problem Definition
pd_results = treePredictions(training_set, training_scores(:, 1), test_set, test_scores(:,1));
% conceptual design
cd_results = treePredictions(training_set, training_scores(:, 2), test_set, test_scores(:,2));
% Preliminary Design
pre_results = treePredictions(training_set, training_scores(:, 3), test_set, test_scores(:,3));
% Detailed Design
dd_results = treePredictions(training_set, training_scores(:, 4), test_set, test_scores(:,4));
% Validation
val_results = treePredictions(training_set, training_scores(:, 5), test_set, test_scores(:,5));
% Implementation
imp_results = treePredictions(training_set, training_scores(:, 6), test_set, test_scores(:,6));
% Process
proc_results = treePredictions(training_set, training_scores(:, 7), test_set, test_scores(:,7));


