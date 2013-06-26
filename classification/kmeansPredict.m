function [predictions, accuracy] = kmeansPredict(model,examples,labels)
% [predictions, accuracy] = kmeansPredict(model,examples,labels)
%
% multiclass predictions using a k-means classifier
%
% model: a k x n matrix, where k = nClasses and n = nDimensions
% examples: an p x n matrix, where p = nExamples and n = nDimensions
% labels: a vector of length p, the labels for each example. Labels should
%   be in the range 1:k, where k = nClasses
%
% predictions: a vector of length p, where p = nExamples, class
%   predictions. The format is the same as for labels.
% accuracy: a scalar, the overall accuracy of the classification
    if (nargin < 3) labels = []; accuracy = nan; end;

    nExamples = size(examples,1);
    nClasses = size(model,1);
    for iExample = 1:nExamples
        distances = pdist([examples(iExample,:); model]);
        [~,predictions(iExample)] = min(distances(1:nClasses));
    end

    if length(labels) == nExamples
        accuracy = sum(predictions == labels)/nExamples;
    end
end
