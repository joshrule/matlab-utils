function plotAplFigure(aucs,nTrainingExamples)
    clf;
    f = figure();

    xs = nTrainingExamples;
    hold on
    errorbar(xs,squeeze(mean(aucs(1,:,:),3)),squeeze(std(aucs(1,:,:),0,3))./sqrt(size(aucs,3)),'b');
    errorbar(xs,squeeze(mean(aucs(2,:,:),3)),squeeze(std(aucs(2,:,:),0,3))./sqrt(size(aucs,3)),'r');
    errorbar(xs,squeeze(mean(aucs(3,:,:),3)),squeeze(std(aucs(3,:,:),0,3))./sqrt(size(aucs,3)),'g');
    errorbar(xs,squeeze(mean(aucs(4,:,:),3)),squeeze(std(aucs(4,:,:),0,3))./sqrt(size(aucs,3)),'k');
    hold off

    xlabel('No. Training Examples');
    ylabel('AUC');
    title('Effect of Patch Type on AUC with Limited Training (human vs. negative)');
    legend('class specific','universal 1000/size (2012)','class-specific + universal 1000/size (2012)','top 50% (class-Specific + universal 1000/size (2012))','Location','Best');
    print(f, '-dpng', ['~/Dropbox/josh/human-negative-gb-with-separation.png']);
end
