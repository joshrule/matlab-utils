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
    if (nargin < 4) k = length(unique(labels))+1; end;

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
end


function w = knnTrain(examples,labels,k,alpha,tolerance)
    if (nargin < 5) tolerance = 10^-5; end;
    if (nargin < 4) alpha = .1; end;

    w = ones(1,k) ./ k;
    deltaW = w;
    nClasses = length(unique(labels));
    nExamples = length(labels);

    % construct B matrices
    B = zeros(nExamples,nClasses,k+1);
    B(:,:,k+1) = 1/k;
    neighbors = knnsearch(examples, examples, 'k',k);
    for iExamples = 1:nExamples
        for iK = 1:k
            kClass = labels(neighbors(iExample,iK));
            B(iExamples,kClass,iK) = 1;
        end
    end

    % hill climb
    while (norm(deltaW) > tolerance)
        w = w .+ deltaW;
        for iK = 1:k
            gradient = -(nExamples*exp(w(iK))/sum(exp(w));
            for iExamples = 1:nExamples
                gradient = gradient + (B(iExample,label(iExample),iK)*exp(w(iK)))/(sum(B(iExample,label(iExample),:))*sum(exp(w)))
            end
            deltaW(iK) = alpha * gradient;
        end
    end
end
