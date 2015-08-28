clear
clc

%% Import data from R of scores and text analysis
DSA_data_table = readtable('DSA_text.csv', 'ReadRowNames', 1, 'TreatAsEmpty', {'NA', 'na', 'N/A'});
DSA_scores = readtable('DSA_scores.csv', 'ReadRowNames', 1, 'TreatAsEmpty', {'NA', 'na', 'N/A'});

DSA_data = table2array(DSA_data_table); % convert to array for decision tree function
DSA_scores = table2array(DSA_scores); % convert to array for decision tree function

DSA_scores(isnan(DSA_scores)) = 0; % replace NaN values with 0 for now

% name of categories to use for table headers:
DSA_rubric = {'Problem_Def', 'Conceptual_Design', 'Prelim_Design', 'Detailed_Design', 'Validation', 'Implementation', 'Process'};
%% separate into training and testing data
training_set = DSA_data([5:10 5:10 5:10 5:10 5:10],:); % need at least 10 samples to grow trees
training_scores = DSA_scores([5:10 5:10 5:10 5:10 5:10],:);

test_set = DSA_data(1:4, :);
test_scores = DSA_scores(1:4, :);

n_bagged_trees = 25; % number of trees to grow for bagged decision tree

%% Predict Classifications
% using custom generateTrees function
% output: first column is actual scores, second is single tree 
% prediction, third is bagged tree prediction

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

%% Rate of correct predictions in bagged tree calculations
% use custom function to calculate the percentage of correct 
% predications using bagged trees

pd_correct = predCorrect(pd_results); 
cd_correct = predCorrect(cd_results);
pre_correct = predCorrect(pre_results);
dd_correct = predCorrect(dd_results);
val_correct = predCorrect(val_results);
imp_correct = predCorrect(imp_results);
proc_correct = predCorrect(proc_results);

correct_predictions = [pd_correct cd_correct pre_correct dd_correct val_correct imp_correct proc_correct];
correct_predictions = array2table(correct_predictions, 'VariableNames', DSA_rubric)

%% out of bag classification error
%bagged_tree = TreeBagger(20,training_set, training_scores(:,1), 'OOBPred','On');
%oobErrorBaggedEnsemble = oobError(bagged_tree);
%plot(oobErrorBaggedEnsemble)
%xlabel 'Number of grown trees';
%ylabel 'Out-of-bag classification error';

%% Generate rubric score for one report

%results = markDSA(test_set(1,:), training_set, training_scores);


