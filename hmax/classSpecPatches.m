function [intra,extra] = classSpecPatches(imgNames,boxNames,patchSizes, ...
  filters,filterSizes,c1Space,c1Scale,c1OL)
% [intra,extra] = classSpecPatches(imgNames,boxNames,patchSizes,filters, ...
%   filterSizes,c1Space,c1Scale,c1OL)
%
% extract two sets of patches, one from inside target bounding boxes and one
% from outside target bounding boxes. If images belong to a single class, you
% create two sets of class-specific patches.
%
% imgNames: cell array of strings, the images from which to extract patches
% boxNames: cell array of strings, the files holding the bounding box
%   annotations for each image
% patchSizes: double array, [4 nSizes] matrix describing the number of rows,
%   columns, orientations, and patches to use for each patch size
% filters: double array, the Gabor filters to use to generate C1 activations
% filterSizes: double array, a vector describing the size of each filter
% c1Scale: double array, the c1Scale of the C1 activation (see C1.m in 'hmax')
% c1Space: double array, the c1Space of the C1 activation  (see C1.m in 'hmax')
% c1OL: double scalar, the overlap to use in calculating C1 activations
%
% intra: struct, the patch set using just information from inside the boxes
% extra: struct, the patch set using just information from outside the boxes
    for iImg = 1:length(imgNames)
        img = grayImage(double(imread(imgNames{iImg})));
        box = readBoxes(imgNames(iImg),boxNames(iImg));
        c1 = C1(img,filters,filterSizes,c1Space,c1Scale,c1OL);
        c1Cropped{iImg} = c1Crop(c1,box{1},'crop',c1Scale,c1Space, ...
          unique(filterSizes));
        c1Punched{iImg} = c1Crop(c1,box{1},'punch',c1Scale,c1Space, ...
          unique(filterSizes));
    end

    [intra.patches,...
     intra.bands,...
     intra.imgs,...
     intra.sizes,...
     intra.locations] = extractedPatches(c1Cropped,patchSizes);

    [extra.patches,...
     extra.bands,...
     extra.imgs,...
     extra.sizes,...
     extra.locations] = extractedPatches(c1Punched,patchSizes);
end
