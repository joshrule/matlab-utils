function auc = auc(predicted,actual,targLabel,dtorLabel)
% auc = auc(predicted,actual,targLabel,dtorLabel)
%
% generates a ROC area (AUC) from classification results
%
% args:
%
%     predicted: a vector, results of the classifier
%
%     actual: a vector, ground truth labels
%
%     targLabel, dtorLabel: the actual tokens used as labels
%
% returns: area, a scalar, the area under the ROC curve (AUC) 

    if (nargin < 3) targLabel = 1; dtorLabel = 0; end;

    % Count observations by class
    nTargets     = sum(double(actual == targLabel));
    nDistractors = sum(double(actual == dtorLabel));

    % Rank data
    R = tiedrank(predicted);

    % Calculate AUC
    area = (sum(R(actual == targLabel)) - (nTargets^2 + nTargets)/2) /...
           (nTargets * nDistractors);
end
