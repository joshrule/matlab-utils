function aucs = plotAucs(m1,m2,m3)
    clf;

%% multiple line types
%   line = ['+' '.' 'o' 'x' '*' 'd' 's'];
%   hold all;
%   for iTrain = 1:size(aucs1,2)
%       errorbar(1:2,...
%                squeeze(mean(aucs1(:,iTrain,:),3)),...
%                squeeze(std(aucs1(:,iTrain,:),0,3))/sqrt(size(aucs1,3)),...
%                line(mod(iTrain,7)+1));
%   end
%   hold off;

%% heat map
%   imagesc(mean(aucs1,3)');
%   h = colorbar;
%   set(get(h,'xlabel'),'string','AUC');
%   caxis([0 1]);
%   axis([0 3 0 10])
%   axis xy

    for i = 1:size(m1,2)
        newM1(i,:) = reshape(m1(:,i,:),1,[]);
        newM2(i,:) = reshape(m2(:,i,:),1,[]);
        newM3(i,:) = reshape(m3(:,i,:),1,[]);
    end

    hold all;
    errorbar(1:10,squeeze(mean(newM1,2)),squeeze(std(newM1,0,2))/sqrt(size(newM1,2)),'b');
    errorbar(1:10,squeeze(mean(newM2,2)),squeeze(std(newM2,0,2))/sqrt(size(newM2,2)),'r');
    errorbar(1:10,squeeze(mean(newM3,2)),squeeze(std(newM3,0,2))/sqrt(size(newM3,2)),'g');
    hold off;

    set(gcf,'DefaultTextInterpreter','None');
    xlabel('Number of Training Examples');
    ylabel('AUC');
%   title('Effect of Patch Set, 940 C3 vs 400/size K-Means C2, 50 ImageNet Categories');
    axis([0 11 00.45 1.0]);
    legend('GB/GB','GB/SVM','SVM/SVM','Location','NorthWest');
    legend boxoff;
    set(gca,'XTick',[0:11]); set(gca,'XTickLabel',{'0','2','4','8','16','32','64','128','160','192','224','...'});
    plotFixFonts(gca,11);
    plot2svg('~/Dropbox/josh/inbox/c3.run1-SVM-total.GB-vs-SVM.auc.svg',gcf);
end
