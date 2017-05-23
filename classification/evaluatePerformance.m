function results = evaluatePerformance(x,y,x_Te,yTe,cv,options,nFeatures,type,scores,nClasses)
% results = evaluatePerformance(x,y,cv,options,nFeatures)
%
% avg. precision and ROC AUC using cross-validation over a set of examples and labels
%
% x: [nFeatures nExamples] array, the feature values
% y: [nClasses nExamples] array, the class labels of examples in x
% cv: cell array of vectors, train/ignore splits, s.t. 1 = train, 0 = ignore
% options: options for the classifier
% nFeatures: scalar, the number of Features to use for classification, must be
%   less than the total number of features in x
% type: string, how to select features
% scores: [nFeatures nExamples] array, scores for feature selection
%
% results: [nClasses, nTrainingExamples, nRuns] struct, the classification data

    if (nargin < 10), nClasses = size(cv,1); end;
    if (nargin < 9), scores = x; end;
    if (nargin < 8), type = 'random'; end;
    [~,nTrainingExamples,nRuns] = size(cv);
    features = cell(nClasses,nTrainingExamples,nRuns);

    for iTrain = 1:nTrainingExamples
        classOrder = randperm(size(cv,1));
        for iClass = 1:nClasses
            theClass = classOrder(iClass);
            parfor iRun = 1:nRuns

                % update the options
                options2 = options;
                options2.dir = [options2.dir '_' num2str(iClass) ...
                                             '_' num2str(iTrain) ...
                                             '_' num2str(iRun)];

                % separate training from non-training examples
                xTr = x(cv{iClass,iTrain,iRun},:);
                yTr = y(cv{iClass,iTrain,iRun},theClass);

                % transform & standardize the data 
                xTr = log(1+xTr);
                xTe = log(1+x_Te);
                [xTr,means,stds] = standardize(xTr);
                xTe = standardize(xTe,means,stds);

                % choose features
                scoresTr = scores(cv{iClass,iTrain,iRun},:);
                features = chooseFeatures(yTr,[],nFeatures,type,scoresTr);
                xTr = xTr(:,features);
                xTe = xTe(:,features);

                % balance the positive and negative examples
                [choices,wTr,xTr,yTr] = balance_pos_neg_examples(xTr,yTr,options2.N);

                % perform the classification
                tmpresults = binary_log_regression(xTr,yTr,wTr,xTe,yTe,options2);
                tmpresults.class = theClass;
                tmpresults.index = iClass;
                tmpresults.nTraining = sum(yTr);
                tmpresults.run = iRun;
                tmpresults = rmfield(tmpresults,'features');
                tmpresults = rmfield(tmpresults,'y_hat');

                % report the results
                saveit([options2.dir '/results.mat'],features,choices);
                results(iClass,iTrain,iRun) = tmpresults;
                fprintf('%d %d %d: %.3f %.3f\n',iClass,iTrain,iRun, ...
                  results(iClass,iTrain,iRun).pr_auc, ...
                  results(iClass,iTrain,iRun).roc_auc);
            end
        end
    end

    results = struct2table(results(:));

end

function saveit(file,chosenFeatures,choices)
    save(file,'chosenFeatures','choices','-append');
end
