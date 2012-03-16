function predictions = knnPredict(testData, trainData, trainLabels, k, distance)
% predictions = knnPredict(testData, trainData, trainLabels, k, distance)
%
% knn-classification, breaking ties by nearest tied class
%
% args:
%
%     testData: a m x n matrix, where m = nTestExamples, n = nFeatures, the
%     testing examples to be predicted
%
%     trainData: a p x n matrix, where p = nTrainExamples, n = nFeatures, the
%     training examples used to generate predictions
%
%     trainLabels: a p-vector, where p = nTrainExamples, the labels of the
%     training examples, should be ints
%
%     k: a scalar, how many neighbors to use in predictions, defaults to 1
%
%     distance: a string, the distance metric to use, defaults to 'euclidean'
%     but accepts any value accepted by knnsearch()
%
% returns: predictions, an m-vector, where m = nTestExamples, the predicted
% class labels for testData

if (nargin < 5) distance = 'euclidean'; end;
if (nargin < 4) k = 1; end;

possibleLabels = sort(unique(trainLabels));
knn = knnsearch(trainData, testData, 'K', k, 'Distance', distance);

for iTest = 1:size(testData,1)
    knnClasses = trainLabels(knn(iTest,:));
    [votes, classes] = sort(hist(knnClasses,possibleLabels),'descend');

    if length(votes) == 1 || votes(1) > votes(2)
        predictions(iTest) = possibleLabels(classes(1));
    else % classes are tied
        tiedClasses = classes(find(votes == votes(1)));
        tieBreaker = min(find(ismember(knnClasses,tiedClasses)));
        predictions(iTest) = possibleLabels(knnClasses(tieBreaker));
    end
end
