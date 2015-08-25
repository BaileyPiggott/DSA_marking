

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

n_bagged_trees = 25; % number of trees to grow for bagged decision tree
%% Problem Definition

% single tree for problem definition score
pd_single_tree = fitctree(training_set, training_scores(:, 1)); % single classification tree
%view(pd_single_tree, 'mode', 'graph'); % view logic in a graph
pd_pred_single = predict(pd_single_tree, test_set);

% bagged tree for problem definition score
pd_bagged_tree = TreeBagger(50,training_set, training_scores(:, 1));
pd_pred_bagged = predict(pd_bagged_tree, test_set); % predictions on test data
pd_pred_bagged = str2num(cell2mat(pd_pred_bagged)); % convert cell array of results to matrix of numbers

% compare predicted problem definition scores
pd_results = [test_scores(:,1) pd_pred_single pd_pred_bagged];

%% conceptual design

% single tree
cd_single_tree = fitctree(training_set, training_scores(:, 2)); % single classification tree
%view(cd_single_tree, 'mode', 'graph'); % view logic in a graph
cd_pred_single = predict(cd_single_tree, test_set);

%bagged tree
cd_bagged_tree = TreeBagger(n_bagged_trees,training_set, training_scores(:, 2));
cd_pred_bagged = predict(cd_bagged_tree, test_set); % predictions on test data
cd_pred_bagged = str2num(cell2mat(cd_pred_bagged)); % convert cell array of results to matrix of numbers

%results
cd_results = [test_scores(:,2) cd_pred_single cd_pred_bagged];

%% Preliminary Design

% single tree
pre_single_tree = fitctree(training_set, training_scores(:, 3)); % single classification tree
%view(pre_single_tree, 'mode', 'graph'); % view logic in a graph
pre_pred_single = predict(pre_single_tree, test_set);

%bagged tree
pre_bagged_tree = TreeBagger(n_bagged_trees,training_set, training_scores(:, 3));
pre_pred_bagged = predict(pre_bagged_tree, test_set); % predictions on test data
pre_pred_bagged = str2num(cell2mat(pre_pred_bagged)); % convert cell array of results to matrix of numbers

%results
pre_results = [test_scores(:,3) pre_pred_single pre_pred_bagged];

%% Detailed Design

% single tree
dd_single_tree = fitctree(training_set, training_scores(:, 4)); % single classification tree
%view(dd_single_tree, 'mode', 'graph'); % view logic in a graph
dd_pred_single = predict(dd_single_tree, test_set);

%bagged tree
dd_bagged_tree = TreeBagger(n_bagged_trees,training_set, training_scores(:, 4));
dd_pred_bagged = predict(dd_bagged_tree, test_set); % predictions on test data
dd_pred_bagged = str2num(cell2mat(dd_pred_bagged)); % convert cell array of results to matrix of numbers

%results
dd_results = [test_scores(:,4) dd_pred_single dd_pred_bagged];

%% Validation

% single tree
val_single_tree = fitctree(training_set, training_scores(:, 5)); % single classification tree
%view(val_single_tree, 'mode', 'graph'); % view logic in a graph
val_pred_single = predict(val_single_tree, test_set);

%bagged tree
val_bagged_tree = TreeBagger(n_bagged_trees,training_set, training_scores(:, 5));
val_pred_bagged = predict(val_bagged_tree, test_set); % predictions on test data
val_pred_bagged = str2num(cell2mat(val_pred_bagged)); % convert cell array of results to matrix of numbers

%results
val_results = [test_scores(:,5) val_pred_single val_pred_bagged];

%% Implementation

% single tree
imp_single_tree = fitctree(training_set, training_scores(:, 6)); % single classification tree
%view(imp_single_tree, 'mode', 'graph'); % view logic in a graph
imp_pred_single = predict(imp_single_tree, test_set);

%bagged tree
imp_bagged_tree = TreeBagger(n_bagged_trees,training_set, training_scores(:, 6));
imp_pred_bagged = predict(imp_bagged_tree, test_set); % predictions on test data
imp_pred_bagged = str2num(cell2mat(imp_pred_bagged)); % convert cell array of results to matrix of numbers

%results
imp_results = [test_scores(:,6) imp_pred_single imp_pred_bagged];

%% Process

% single tree
proc_single_tree = fitctree(training_set, training_scores(:, 7)); % single classification tree
%view(proc_single_tree, 'mode', 'graph'); % view logic in a graph
proc_pred_single = predict(proc_single_tree, test_set);

%bagged tree
proc_bagged_tree = TreeBagger(n_bagged_trees,training_set, training_scores(:, 7));
proc_pred_bagged = predict(proc_bagged_tree, test_set); % predictions on test data
proc_pred_bagged = str2num(cell2mat(proc_pred_bagged)); % convert cell array of results to matrix of numbers

%results
proc_results = [test_scores(:,7) proc_pred_single proc_pred_bagged];
