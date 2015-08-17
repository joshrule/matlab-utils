function [aucs,dprimes,models,classVals,features] = evaluatePerformance(x,y,cv,method,options,nFeatures,classOrigin,type,scores)
% [aucs,dprimes,models,classVals] = evaluatePerformance(x,y,cv,method,options,nFeatures,classOrigin)
%
% Give AUC and d' scores using cross-validation over a set of examples and labels
%
% x: [nFeatures nExamples] array, the feature values
% y: [nClasses nExamples] array, the class labels of examples in x
% classifier: a string, the classifier to use, svm or gentleboost
% cv: cell array of vectors, the train/test splits, where 1 = train, 0 = test
% method: string, 'svm' or 'gb', use SVM or GentleBoost
% options: options for the classifier
% nFeatures: scalar, the number of Features to use for classification, must be
%   less than the total number of features in x
% classOrigin: nExamples vector, denotes the class of origin for each example
%   and is used solely for choosing features. If empty, features are chosen at
%   random. Otherwise, the top features per class are chosen by FI (fisher.m)
%
% aucs: [nClasses, nTrainingExamples, nRuns] array, the AUC scores
% dprimes: [nClasses, nTrainingExamples, nRuns] array, the d' scores
% models: [nClasses, nTrainingExamples, nRuns] cell, the classifiers
% classVals: [nClasses, nTrainingExamples, nRuns] cell, classification values
    if (nargin < 9), scores = x; end;
    if (nargin < 8), type = 'random'; end;
    [nClasses,nTrainingExamples,nRuns] = size(cv);
    aucs = zeros(nClasses,nTrainingExamples,nRuns);
    dprimes = zeros(nClasses,nTrainingExamples,nRuns);
    for iClass = 1:nClasses
        for iTrain = 1:nTrainingExamples
            parfor iRun = 1:nRuns
                if(iscell(x))
                    X = x{iClass,iRun};
                else
                    X = x;
                end
                featX = X(:,cv{iClass,iTrain,iRun});
                scoresX = scores(:,cv{iClass,iTrain,iRun});
                features{iClass,iTrain,iRun} = chooseFeatures(featX,y(iClass,cv{iClass,iTrain,iRun}),classOrigin,nFeatures,type,scoresX);
                [classificationValues,model] = classifyResponses(X(features{iClass,iTrain,iRun},:),y(iClass,:),cv{iClass,iTrain,iRun},method,options);
                if strcmp(lower(method),'svm')
                    classPredictions = (classificationValues > 0.5);
                else
                    classPredictions = (sign(classificationValues)+1)./2;
                end
                models{iClass,iTrain,iRun} = model;
                classVals{iClass,iTrain,iRun} = classificationValues;
                aucs(iClass,iTrain,iRun) = auc(classificationValues,y(iClass,~cv{iClass,iTrain,iRun}));
                dprimes(iClass,iTrain,iRun) = dprime(classPredictions,y(iClass,~cv{iClass,iTrain,iRun}),1,0);
                fprintf('%d %d %d: %.3f %.3f\n',iClass,iTrain,iRun,aucs(iClass,iTrain,iRun),dprimes(iClass,iTrain,iRun));
            end
        end
    end
end
