function x= plotMap(m)

    for i = 1:length(m)
        x(i,:) = mean(m{i},3)';
    end

    fprintf('Max AUC: %.3f\nMin AUC: %.3f\n',max(max(x)),min(min(x)));

    clf; f = figure();
    imagesc(x);

    xlabel('# Training Examples');
    ylabel('# Features');
    title('Effect of Training Examples and Features on AUC, 2,500 patches/size, class specific, Face vs. Animal/No-Animal');
    
    set(gca,'YTick', 1:18);
    set(gca,'YTickLabel', [1 2 4 8 10 20 40 80 100 200 400 800 1000 2000 4000 8000 10000 20000]);
    set(gca,'XTick', 1:2:35);
    set(gca,'XTickLabel', [2 8 32 128 192:64:1024]);
    axis tight

    h = colorbar;
%   caxis([0 4]);
    colormap(hot);

    print(f, '-dpng', '~/Dropbox/josh/inbox/usfr.face-class-specific-AUC-map.all.png');
end
