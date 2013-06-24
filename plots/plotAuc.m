function aucs = plotAucs(c2rs,labels,cv)
    clf; f = figure();

    for iType = 1:length(c2rs)
        for iClass = 1:length(c2rs{iType})
            for iTrain = 1:length(c2rs{iType}{iClass})
                xs(iTrain) = cv{1}{iTrain}{1}.TrainSize;
                for iRep = 1:length(c2rs{iType}{iClass}{iTrain})
                    aucs(iType,iClass,iTrain,iRep) = evaluateResponses(labels,c2r,cv)
                end
            end
        end
    end

    hold all;
    for iType = 1:length(c2rs)
        errorbar(xs,...
                 squeeze(mean(aucs(iType,:,:,:),4)),...
                 squeeze(std(aucs(iType,:,:,:),0,4))./sqrt(size(aucs,4)));
    end
    hold off;

    xlabel('No. Training Examples');
    ylabel('AUC');
    title('Effect of Patch Type on AUC with Limited Training (animal vs. negative)');
    legend('universal 1000/size (2012)','untargeted','targeted','Location','Best');
    print(f, '-dpng', ['~/Dropbox/josh/inbox/pnas-svm.png']);
end
