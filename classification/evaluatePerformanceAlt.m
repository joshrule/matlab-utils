function [top1,top5,models,classVals,features] = evaluatePerformanceAlt( ...
  xTr,yTr,xTe,yTe,cv,method,options,nFeatures,classOrigin,type,scores)
% function [aucs,dprimes,models,classVals,features] = evaluatePerformanceAlt( ...
%   xTr,yTr,xTe,yTe,cv,method,options,nFeatures,classOrigin,type,scores)
%
% Give AUC and d' scores using cross-validation over a set of examples and labels
%
% xTr: [nFeatures nExamples] array, the training feature values
% yTr: [nClasses nExamples] array, the class labels of examples in xTr
% xTe: [nFeatures nExamples] array, the testing feature values
% yTe: [nClasses nExamples] array, the class labels of examples in xTe
% classifier: a string, the classifier to use, svm or gentleboost
% cv: cell array of vectors, the train/test splits, where 1 = train, 0 = ignore
% method: string, 'svm' or 'gb', use SVM or GentleBoost
% options: options for the classifier
% nFeatures: scalar, the number of Features to use for classification, must be
%   less than the total number of features in x
% classOrigin: nExamples vector, denotes the class of origin for each example
%   and is used solely for choosing features. If empty, features are chosen at
%   random. Otherwise, the top features per class are chosen by FI (fisher.m)
%
% top1: [nClasses, nTrainingExamples, nRuns] array, the top-1 performance
% top5: [nClasses, nTrainingExamples, nRuns] array, the top-5 performance
% models: [nClasses, nTrainingExamples, nRuns] cell, the classifiers
% classVals: [nClasses, nTrainingExamples, nRuns] cell, classification values
    if (nargin < 9), scores = xTr; end;
    if (nargin < 8), type = 'random'; end;
    [nClasses,nTrainingExamples,nRuns] = size(cv);
    top1 = zeros(nClasses,nTrainingExamples,nRuns);
    top5 = zeros(nClasses,nTrainingExamples,nRuns);
    for iTrain = 1:nTrainingExamples
        for iRun = 1:nRuns
            if(iscell(xTr))
                X = xTr{1,iRun};
            else
                X = xTr;
            end
            featX = X(:,cv{1,iTrain,iRun});
            scoresX = scores(:,cv{1,iTrain,iRun});
            features{1,iTrain,iRun} = chooseFeatures(featX,yTr(1,cv{1,iTrain,iRun}),classOrigin,nFeatures,type,scoresX);
            x_classify = [X(features{1,iTrain,iRun},cv{1,iTrain,iRun}) xTe(features{1,iTrain,iRun},:)];
            y_classify = [yTr(:,cv{1,iTrain,iRun}) yTe];
            training = [true(sum(cv{1,iTrain,iRun}),1); false(size(xTe,2),1)];

            keyboard % debug!

            [classificationValues,model] = classifyResponses(x_classify,y_classify,logical(training),method,options);

            models{1,iTrain,iRun} = model;
            classVals{1,iTrain,iRun} = classificationValues;
            top1(1,iTrain,iRun) = top_k(classificationValues,yTe,1);
            top5(1,iTrain,iRun) = top_k(classificationValues,yTe,5);
            fprintf('%d %d %d: %.3f %.3f\n',1,iTrain,iRun,top1(1,iTrain,iRun),top5(1,iTrain,iRun));
        end
    end
end

function topK = top_k(classificationValues,trainY,k)
    topKs = nan(size(trainY,1),1);
    for item = 1:size(trainY,1)
        [~,idxs] = sort(classificationValues(item,:),'descend');
        topKs(item) = ismember(trainY(item),idxs(1:k));
    end
    topK = mean(topKs);
end
