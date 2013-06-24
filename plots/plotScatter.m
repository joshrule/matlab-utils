function plotScatter(v1,v2,label1,label2)
    clf; f = figure();
    hold all;
    scatter(v1,v2);
    hold off;

    xlabel(label1);
    ylabel(label2);
    title('Mean FI vs. Max FI across categories, Master Patches, 2x2, ImageNet');
    % axis([0 10 0.45 1.0]);
    % legend('item 1','item 2','Location','Best'); legend boxoff;
    %set(gca,'XTick',0:10); set(gca,'XTickLabel',{'0','2','4','8','16','32','64','128','162','196','...'});
    %plot2svg('~/Dropbox/josh/inbox/imgOut.svg',f);
    print(f,'-dpng','~/Dropbox/josh/inbox/master-patches-FI-scatterplot.png');
end
