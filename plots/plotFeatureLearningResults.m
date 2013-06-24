function plotFeatureLearningResults(rocareas,nTrainingIterations)
f = figure('Position',[1782         648         680         430]);
imagesc(squeeze(rocareas(1:nTrainingIterations,:)))
xlabel('Percentage best-matching patches updated')
ylabel('Training iteration')
title('Restricted Animal/No-Animal (300/class)');
set(gca, 'XTick',1:12);
set(gca, 'XTickLabel',1:9:100);
h = colorbar;
set(get(h,'xlabel'),'string','AUC','fontsize',16,'fontweight','bold');
fixFonts
print(f, '-dpng', '~/current-feature-learning-results.png');
