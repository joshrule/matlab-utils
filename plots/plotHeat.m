function plotHeat(m,key)

    clf; f = figure();

    imagesc(m);

    h = colorbar;
    set(get(h,'xlabel'),'string',key);
    caxis([0 max(max(m))]);

    xlabel('Category');
    ylabel('# Training Examples');
    set(gca,'YTickLabel',{'2','4','8','16','32','64','128','160','196','228'});
    title('Individual Effects of # Training Examples (400 patches/size, ImageNet)');
%   axis([0.5 10.5 0.5 9.5])
    axis xy

    print(f, '-dpng', '~/Dropbox/josh/inbox/c3.individual-results.d-prime-heat.png');
