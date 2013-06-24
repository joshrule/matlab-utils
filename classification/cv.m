function cv = cv(y,nTrainingExamples,nRuns)
% cv = genCV(y,nTrainingExamples,nRuns)
    for iClass = 1:size(y,1)
        for iTrain = 1:length(nTrainingExamples)
            for iRun = 1:nRuns
                cv{iClass,iTrain,iRun} = equalRep(y(iClass,:),floor(nTrainingExamples(iTrain)/2));
            end
        end
    end
end
