function [classificationValues,model] = classifyResponses(trainX,testX,trainY,testY,classifier,options)
% [classificationValues,model] = classifyResponses(trainX,testX,trainY,testY,classifier,options)
%
% return classification values for binary classification over an image set
%
% classificationValues: the classification estimates from the classifier
% model: the classifier generating the estimates
    if (nargin < 5) options = []; end;
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
        classificationValues = allVal(:,labelOrder);
      case {'gb','gentleboost'}
        if isempty(options) options = 100; end;
        trainY = double(trainY).*2 - 1; % [0,1] -> [-1,1]
        model = gentleBoost(trainX',trainY',options);
        [~,classificationValues] = strongGentleClassifier(testX',model);
      case {'logreg'}
          [classificationValues,model] = log_reg_in_caffe(trainX,trainY,testX,testY,options);
      otherwise
        classificationValues = [];
        model = [];
    end
end
