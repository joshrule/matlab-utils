function auc = auc(predicted,actual,posLabel,negLabel)
% auc = auc(predicted,actual,posLabel,negLabel)
%
% generates a ROC area (AUC) from classification results
%
% predicted: double aray, vector of classification values
% actual: double array, vector of ground truth labels
% posLabel, negLabel: the actual tokens used as labels
%
% auc: scalar double, the area under the ROC curve (AUC) 
    if (nargin < 3) posLabel = 1; negLabel = 0; end;

    % Count observations by class
    nPos = sum(double(actual == posLabel));
    nNeg = sum(double(actual == negLabel));

    % Rank data
    R = tiedrank(predicted);

    % Calculate AUC
    auc = (sum(R(actual == posLabel)) - (nPos^2 + nPos)/2)/(nPos * nNeg);
end
