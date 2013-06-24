function plotCategoryImprovement(diffs,categories,plotTitle)
    clf; f = figure();

    hold on;
    errorbar(mean(diffs,2),std(diffs,0,2)/sqrt(size(diffs,2)),'xb');
    plot(1:100,zeros(1,100),'k-');
    hold off;

    ylabel('difference in AUC (200-100)');
    xlabel('category');
    title(plotTitle);
    
%   set(gca,'XTick', 1:length(categories));
%   set(gca,'XTickLabel', categories);
    axis([1 100 -.1 .1])
    axis 'auto y'

    plotTitle(isspace(plotTitle)) = '-';
    print(f, '-dpng', ['~/Dropbox/josh/inbox/' lower(plotTitle) '.png']);
end
