function cv = genCV(y,nTrainingExamples,nRuns)
    for iClass = 1:size(y,1)
        for iTrain = 1:length(nTrainingExamples)
            for iRun = 1:nRuns
                cv{iClass,iTrain,iRun} = equalRep(y(iClass,:),nTrainingExamples(iTrain)/2);
            end
        end
    end
end
