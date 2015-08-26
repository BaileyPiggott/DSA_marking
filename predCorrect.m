function [ correct_pred ] = predCorrect( results )
% Calculate correct prediction rate for DSA marking
% inputs are the predicitons from one of the 7 sections using the 
% custom treePrediction function (in table form)
right = 0;

for i =1:height(results)
    if (results{i,1} == results{i,3})
        right = right + 1;
    end
end
correct_pred = right / height(results);

end



