function plotDirSample(imgDir,ext,r,c,plotFile)
% plotDirSample(imgDir,ext,r,c,plotFile)
%
% given a directory of images and a grid size, plot a grid of images 
%
% imgDir: string, the absolute path of an image directory
% ext: string, the extension of the images in the directory
% r: scalar double, the number of rows in the grid
% c: scalar double, the number of columns in the grid
% plotFile: string, the absolute path to which to write the image on disk
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
    plot2svg(plotFile,gcf);
end
