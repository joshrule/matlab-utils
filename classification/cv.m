function cv = cv(y,nTrainingExamples,nRuns)
% cv = genCV(y,nTrainingExamples,nRuns)
%
% create a set of train/test splits for cross-validation
%
% y: [nClasses nExamples] array, class labels
% nTrainingExamples: vector, use 1/2 of each entry as positive and 1/2 as
%   negative (i.e. 512 means 256 positives and 256 negatives)
% nRuns: scalar, the number of repetitions for each number of training examples
%
% cv: cell array of vectors, the train/test splits, where 1 = train, 0 = test
    for iClass = 1:size(y,1)
        for iTrain = 1:length(nTrainingExamples)
            for iRun = 1:nRuns
                cv{iClass,iTrain,iRun} = equalRep(y(iClass,:), ...
                  floor(nTrainingExamples(iTrain)/2));
            end
        end
    end
end
