function plotClusterFig(clusts,patches,maxSize,c1Scale,c1Space,rfSizes,outDir)
% plotClusterFig(clusts,patches,maxSize,c1Scale,c1Space,rfSizes,outDir)
    clf;
    for iClust = 1:length(clusts)
        clusterPatches = patches(find([patches.clust] == clusts(iClust)));
        hold on
        for i = 1:min(length(clusterPatches),5)
            p = clusterPatches(i);
            imgName = regexprep(p.img,'josh','joshrule');
            iImg = resizeImage(imread(imgName),maxSize);
            iPatch = drawPatch(iImg,p.band,p.x1,p.x2,p.y1,p.y2,c1Scale,c1Space,rfSizes);
            (i-1)*6+iClust
            subplot(5,6,(i-1)*6+iClust);
            imagesc(uint8(iPatch));
            axis off;
        end
        hold off
    end
end
