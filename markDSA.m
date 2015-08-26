function [ marks ] = markDSA( report, training_set, training_scores )
% function to mark all 7 DSA rubric categories
% and output a nice table of scores


for i = 1:7 % each of the DSA rubric categories
    bagged_tree = TreeBagger(25,training_set, training_scores(:, i));
    pred_bagged = predict(bagged_tree, report); % predictions on test data
    pred_bagged = str2num(cell2mat(pred_bagged)); % convert cell array of results to matrix of numbers
    
    marks(i) = pred_bagged;
end

marks = array2table(marks, 'VariableNames', {'Problem_Definition', 'Conceptual_Design', 'Prelim_Design', 'Detailed_Design', 'Validation', 'Implementation', 'Process'});


end

