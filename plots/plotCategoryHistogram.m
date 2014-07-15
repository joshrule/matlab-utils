function [] = plotCategoryHistogram(data,xLabel,plotTitle,plotFile)
% plotCategoryHistogram(data,yLabel,title,file)
%
% plot a set of performance scores as a histogram
%
% data: nCategories x nSplits double array, the data to plot
% yLabel: string, the label for the y-axis
% plotTitle: string, the label for the entire plot
% plotFile: string, the absolute path to which to write the image on disk
    clf;

    hist(data(:),200);

    set(gcf,'DefaultTextInterpreter','None');
    xlabel(xLabel);
    ylabel('# Categories');
    title(plotTitle);

    axis([0 5.5 0 50]);
    print(gcf,'-depsc',plotFile);
end
