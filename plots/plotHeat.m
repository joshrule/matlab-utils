function plotHeat(m,barLabel,xLabel,yLabel,plotTitle,plotFile,ticks)
% plotHeat(m,barLabel,xLabel,yLabel,plotTitle,plotFile,ticks)
%
% plot a heatmap
%
% m: double array, the matrix to plot
% barLabel: string, the label for the colorbar
% xLabel: string, the label for the x-axis
% yLabel: string, the label for the y-axis
% plotTitle: string, the label for the entire plot
% plotFile: string, the absolute path to which to write the image on disk
% ticks: r vector, where r is the number of rows in the data
    clf;

    imagesc(m);

    h = colorbar;
    set(get(h,'xlabel'),'string',barLabel);
    caxis([0 max(m(:))]);

    set(gcf,'DefaultTextInterpreter','None');
    xlabel(xLabel);
    ylabel(yLabel);
    set(gca,'YTickLabel', ...
      ['0' regexp(sprintf('%i ',ticks),'(\d+)','match') '...']);
    title(plotTitle);
    axis xy

    plotFixFonts(gca,11);
    plot2svg(plotFile,gcf);
end
