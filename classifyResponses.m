function classificationValues = classifyResponses(x,y,training,classifier,options)
%
% a set of classification values for binary classification over an image set
%
% x: an [nFeatures nExamples] array holding feature values
% y: a vector of length nExamples, the class labels of examples in x
% training: a logical vector of length nExamples, examples in training set = 1
% classifier: a string, the classifier to use, svm or gentleboost
%
% classificationValues: the classification estimates from the classifier

    if (nargin < 5) options = []; end;
    trainX = x(:, training)';
    testX  = x(:,~training)';
    trainY = y( training)';
    testY  = y(~training)';
    switch lower(classifier)
      case {'svm','libsvm'}
        if isempty(options) options = '-q -t 0 -b 1'; end;
        model = svmtrain(trainY,trainX,options);
        [~,~,allVals] = svmpredict(testY,testX, model,'-b 1');
        classificationValues = allVals(:,2-trainY(1));
      case {'gb','gentleboost'}
        if isempty(options) options = 100; end;
        trainY = double(trainY).*2 - 1; % [0,1] -> [-1,1]
        model = gentleBoost(trainX',trainY',options);
        [~,classificationValues] = strongGentleClassifier(testX',model);
      otherwise
        classificationValues = [];
    end
end
