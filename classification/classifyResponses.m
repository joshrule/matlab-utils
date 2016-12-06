function [classificationValues,model] = classifyResponses(x,y,training, ...
  classifier,options)
% [classificationValues,model] = classifyResponses(x,y,training,classifier, ...
%   options)
%
% return classification values for binary classification over an image set
%
% x: an [nFeatures nExamples] array holding feature values
% y: a vector of length nExamples, the class labels of examples in x
% training: a logical vector of length nExamples, examples in training set = 1
% classifier: a string, the classifier to use, svm or gentleboost
%
% classificationValues: the classification estimates from the classifier
% model: the classifier generating the estimates
    if (nargin < 5) options = []; end;
    trainX = x(:, training)';
    testX  = x(:,~training)';
    trainY = y(:, training)';
    testY  = y(:,~training)';
    switch lower(classifier)
      case {'svm','libsvm'}
        if isempty(options) options = '-q -t 0 -s 0 -b 1'; end;
        [trainX,minVals,maxVals] = libsvmScaleData(trainX,0,1);
        [~,svmTrainY] = ind2sub(size(trainY),find(trainY));
        [~,svmTestY] = ind2sub(size(testY),find(testY));
        model = svmtrain(svmTrainY,trainX,options);
        testX = libsvmScaleData(testX,0,1,minVals,maxVals);
        [~,~,allVals] = svmpredict(svmTestY,testX,model,'-b 1');
        % re-order the classification values from lowest class to highest class
        [vals,labelOrder] = sort(unique(svmTrainY,'stable'),'ascend')
        vals
        classificationValues = allVal(:,labelOrder);
      case {'gb','gentleboost'}
        if isempty(options) options = 100; end;
        trainY = double(trainY).*2 - 1; % [0,1] -> [-1,1]
        model = gentleBoost(trainX',trainY',options);
        model
        [~,classificationValues] = strongGentleClassifier(testX',model);
      case {'mlr','mnrfit'}
          % use options to encode the tmp directory
          [classificationValues,model] = mnrfit_python(options,trainX,trainY,testX,testY);
          % model = mnrfit(trainX,trainY);
          % classificationValues = mnrval(model,testX);
      otherwise
        classificationValues = [];
    end
end

function [classificationValues,model] = mnrfit_python(outDir,trainX,trainY,testX,testY)
% mnrfit_python(trainX,trainY)
%
% This function takes arguments for doing multinomial logistic regression and
% regresses in Python. It returns the classification values and the model.

% convert the training labels
[~,trainY] = ind2sub(size(trainY),find(trainY));
[~,testY] = ind2sub(size(testY),find(testY));

% save the values
ensureDir(outDir);
save([outDir 'tmp.mat'],'trainY','trainX','testX','testY');

% call the python function
system(['python mnlr.py ' outDir 'tmp.mat']);

% load the saved values
load([outDir 'tmp.mat'],'classificationValues','model');

classificationValues = classificationValues;
model = model;

delete([outDir 'tmp.mat']);
end
