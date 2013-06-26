function plotLinesWithErrors(ms,legendLabels,xLabel,yLabel,plotTitle, ...
  plotFile,ticks)
% plotLinesWithErrors(ms,legendLabels,xLabel,yLabel,plotTitle,plotFile,ticks)
%
% plot a set of performance scores with error bars
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
    minVal = bitmax;
    maxVal = 0;
    for i = 1:length(ms)
        for j = 1:size(ms{i},2)
            ms2{i}(j,:) = reshape(ms{i}(:,j,:),1,[]);
        end
        maxVal = max(maxVal,max(ms2{i}(:)));
        minVal = min(maxVal,min(ms2{i}(:)));
        errorbar(1:length(ticks),squeeze(mean(ms2{i},2)), ...
          squeeze(std(ms2{i},0,2))/sqrt(size(ms2{i},2)));
    end
    hold off;

    set(gcf,'DefaultTextInterpreter','None');
    xlabel(xLabel);
    ylabel(yLabel);
    title(plotTitle);

    axis([0 length(ticks)+1 floor(minVal) ceil(maxVal)]);
    set(gca,'YTickLabel', ...
      ['0' regexp(sprintf('%i ',ticks),'(\d+)','match') '...']);

    legend(legendLabels{:},'Location','Best');
    legend boxoff;

    plotFixFonts(gca,11);
    plot2svg(plotFile,gcf);
end
