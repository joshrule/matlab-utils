function [aucs,dprimes,models] = evaluatePerformance(x,y,cv,method,options,nFeatures,classOrigin)
% [aucs,dprimes,models] = evaluatePerformance(x,y,cv,method,options,nFeatures,classOrigin)
    [nClasses,nTrainingExamples,nRuns] = size(cv);
    aucs = zeros(nClasses,nTrainingExamples,nRuns);
    dprimes = zeros(nClasses,nTrainingExamples,nRuns);
    for iClass = 1:nClasses
        for iTrain = 1:nTrainingExamples
            parfor iRun = 1:nRuns
                fprintf('%d %d %d\n',iClass,iTrain,iRun);
                if(iscell(x))
                    X = x{iClass,iRun};
                else
                    X = x;
                end
                [classificationValues,model] = classifyResponses(X(chooseFeatures(X(:,cv{iClass,iTrain,iRun}),y(iClass,cv{iClass,iTrain,iRun}),classOrigin,nFeatures),:),y(iClass,:),cv{iClass,iTrain,iRun},method,options);
                if strcmp(lower(method),'svm')
                    classPredictions = sign(classificationValues);
                else
                    classPredictions = (sign(classificationValues)+1)./2;
                end
                models{iClass,iTrain,iRun} = model;
                aucs(iClass,iTrain,iRun) = auc(classificationValues,y(iClass,~cv{iClass,iTrain,iRun}));
                dprimes(iClass,iTrain,iRun) = dprime(sign(classPredictions),y(iClass,~cv{iClass,iTrain,iRun}),1,0);
            end
        end
    end
end
