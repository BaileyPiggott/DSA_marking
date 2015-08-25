function [ results ] = treePredictions( training_data, training_scores, test_data, test_scores )
% generate single and bagged decision trees and
% predict classification for test data

%single tree
single_tree = fitctree(training_data, training_scores); % single classification tree
pred_single = predict(single_tree, test_data);

% bagged tree 
bagged_tree = TreeBagger(25,training_data, training_scores);
pred_bagged = predict(bagged_tree, test_data); % predictions on test data
pred_bagged = str2num(cell2mat(pred_bagged)); % convert cell array of results to matrix of numbers

% compare predictions to actual score
results = [test_scores pred_single pred_bagged];

end

