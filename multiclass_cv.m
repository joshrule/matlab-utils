function cv = multiclass_cv(labels,nTrainingExamples,nRuns)
% cv = multiclass_cv(labels,nTrainingExamples,nRuns)
%
% create a multi-class set of train/test splits for cross-validation
%
% y: [nClasses nExamples] array, class labels
% nTrainingExamples: vector, use each entry as the number of examples to be
%   selected in each class.
% nRuns: scalar, the number of repetitions for each number of training examples
%
% cv: cell array of vectors, the train/test splits, where 1 = train, 0 = test
    cv = cell(length(nTrainingExamples),nRuns);
    for iTrain = 1:length(nTrainingExamples)
        nExamples = nTrainingExamples(iTrain);
        for iRun = 1:nRuns
            cv{iTrain,iRun} = false(size(labels,2),1);
            for iClass = 1:size(labels,1)
                potentialImages = find(labels(iClass,:));
                shuffledImages = randperm(length(potentialImages));
                chosenImages = potentialImages(shuffledImages(1:nExamples));
                cv{iTrain,iRun}(chosenImages) = true;
            end
        end
    end
end
