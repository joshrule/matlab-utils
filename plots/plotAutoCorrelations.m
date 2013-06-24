function correlations = plotAutoCorrelations(c2r,labels,type,bounds,title)
    clf; f = figure();
    
    correlations = autocorrelations(c2r',labels,type,50);

    hold on;
    imagesc(correlations);
    plot([bounds' bounds'],[0 length(correlations)],'k');
    plot([0 length(correlations)],[bounds' bounds'],'k');
    hold off;

    xlabel('class');
    ylabel('class');
    title([title ' Auto-Correlations']);
    axis([0 length(correlations) 0 length(correlations)]);
    axis ij
    
    h = colorbar;
    set(get(h,'xlabel'),'string','AC');
    caxis([-1 1]);

    print(f, '-dpng', ['~/Dropbox/josh/inbox/' title '-autocorrelations.png']);
end
