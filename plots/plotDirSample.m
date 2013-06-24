function plotClusterFig(imgDir,ext,r,c)
% plotClusterFig(clusts,patches,maxSize,c1Scale,c1Space,rfSizes,outDir)
    clf;
    potentialImages = dir([imgDir '*.' ext]);        
    potentialNames = strcat(imgDir, {potentialImages.name});
    chosenNames = potentialNames(randperm(length(potentialNames),r*c));
    ha = tight_subplot(r, c, 0.01, 0.01, 0.01);
    for i = 1:r*c
        axes(ha(i));
        imagesc(uint8(imread(chosenNames{i})));
        axis image;
        axis off;
    end
end
