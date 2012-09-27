function aucs = evaluatePerformance(x,y,cv,method)
    [nClasses,nTrainingExamples,nRuns] = size(cv);
    aucs = zeros(nClasses,nTrainingExamples,nRuns);
    for iClass = 1:nClasses
        for iTrain = 1:nTrainingExamples
            parfor iRun = 1:nRuns
                fprintf('%d %d %d\n',iClass,iTrain,iRun);
                if(iscell(x))
                    X = x{iClass,iTrain,iRun};
                else
                    X = x;
                end
                aucs(iClass,iTrain,iRun) = auc(classifyResponses(X(chooseFeatures(X,y(iClass,:)),:),...
                                                                 y(iClass,:),...
                                                                 cv{iClass,iTrain,iRun},...
                                                                 method),...
                                               y(iClass,~cv{iClass,iTrain,iRun}));
            end
        end
    end
end
