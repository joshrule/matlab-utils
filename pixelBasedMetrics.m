function [pMin,pMax,pMean] = pixelBasedMetrics(imgNames,boxSize,maxSize)
% [pMin,pMax,pMean] = pixelBasedMetrics(imgNames,boxSize,maxSize)
%
% compare two images based on a variety of metrics, providing a set of
% pixel-based features
%
% imgNames: 
% blockSize: 2 vector, the rows and columns of the pixel blocks
% maxSize: scalar, maximum edge length when resizing images
%
% pMin, pMax, pMean: vectors, for each 'blockSize' area in each image, the min,
%   max, or mean pixel value, respectively
    parfor iImg = 1:length(imgNames)
        img = uint8(resizeImage(double(imread(imgNames{iImg})), maxSize));
        pMin(iImg,:) = blockproc(img,boxSize,@(x) min(x.data(:)));
        pMax(iImg,:) = blockproc(img,boxSize,@(x) max(x.data(:)));
        pMean(iImg,:) = blockproc(img,boxSize,@(x) mean(x.data(:)));
        pStd(iImg,:) = blockproc(img,boxSize,@(x) std(x.data(:)));
    end
end
