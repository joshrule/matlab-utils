function plotScatter(v1,v2,legendLabels,xLabel,yLabel,plotTitle,plotFile,ticks)
% plotScatter(v1,v2,legendLabels,xLabel,yLabel,plotTitle,plotFile,ticks)
%
% write a scatter plot to disk
%
% ms: cell array of double arrays, the matrices to plot
% legendLabels: cell array of strings, the entries for the legend
% xLabel: string, the label for the x-axis
% yLabel: string, the label for the y-axis
% plotTitle: string, the label for the entire plot
% plotFile: string, the absolute path to which to write the image on disk
% ticks: r vector, where r is the number of rows in the data
    clf;

    hold all;
    scatter(v1,v2);
    hold off;

    xlabel(xLabel);
    ylabel(yLabel);
    title(plotTitle);

    axis([0 length(ticks)+1 floor(v2) ceil(v2)]);
    set(gca,'YTickLabel', ...
      ['0' regexp(sprintf('%i ',ticks),'(\d+)','match') '...']);

    legend(legendLabels{:},'Location','Best');
    legend boxoff;

    plot2svg(plotFile,f);
end
