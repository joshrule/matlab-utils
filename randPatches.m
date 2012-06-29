function [patches bandsChosen imgChosen sizesChosen] = randPatches(imgs, nPatchesPerSize, patchSizes, USECROPS)
% [patches bandsChosen imgChosen sizesChosen] = randPatches(imgs, nPatchesPerSize, patchSizes, USECROPS)
%
% extracts random patches for use as S2 features.
%
% args:
%
%     imgs: a cell array of image filenames, the images to be mined for patches
%
%     nPatchesPerSize: a scalar, the number of patches to create per size
%
%     patchSizes: a 3 x nPatchSizes array of patch sizes 
%     Each column should hold [nRows; nCols; nOrientations]
%
%     USECROPS: a logical, if true, cropped images will be used for patch
%     extraction if available
%
% returns:
%
%     patches: a cell array of length nPatchSizes, with the cell at index i
%     containing an [prod(patchSizes(:,i)) nPatchesPerSize] array representing
%     the extracted patches
%
%     bandsChosen: an [1 nPatchesTotal] array, the band selected for each patch
%
%     imgChosen: an [1 nPatchesTotal] array, the image selected for each patch
%
%     sizesChosen: an [1 nPatchesTotal] array, the size selected for each patch

if (nargin < 4) USECROPS = 0; end;
if (nargin < 3) patchSizes = [4 8 12; 4 8 12; 4 4 4]; end;
if (nargin < 2) nPatchesPerSize = 500; end;

% hard-wired "parameters" for training patches
nImgs = length(imgs);
nPatchSizes = size(patchSizes,2);
nPatchesTotal = nPatchSizes*nPatchesPerSize;
orientations = [90 -45 0 45];
div     = [4:-.05:3.2];
c1Scale = [1:2:18];
c1Space = [8:2:22];
RFsize  = [7:2:39];
INCLUDEBORDERS = 0;

% initialize Gabor filters
[filterSizes,filters,c1OL,~] = initGabor(orientations, RFsize, div);

% select patch source images and get their S1/C1 activations
sourceImgs = imgs(ceil(rand(1,nPatchesTotal)*nImgs));
for iImg = 1:nPatchesPerSize % reuse images for multiple patches
    img = readImages(sourceImgs(iImg),USECROPS);
    c1r{iImg} = C1(img{1},filters,filterSizes,c1Space,c1Scale,c1OL,...
                   INCLUDEBORDERS);
end

% select patches from random C1 bands
count = 1;
for iPatch = 1:nPatchesPerSize
    b = c1r{iPatch};
    for iSize = 1:nPatchSizes
        foundBand = 0;
        while (~foundBand)
            randBand = ceil(rand() * length(b));
            bandRows = size(b{randBand},1);
            bandCols = size(b{randBand},2);
            x = floor(rand()*(bandRows-patchSizes(1,iSize)))+1;
            y = floor(rand()*(bandCols-patchSizes(2,iSize)))+1;
            if x > 0 && y > 0
                foundBand = 1;
                bandsChosen(1,count) = randBand;
                sizesChosen(1,count) = iSize;
                imgChosen{1,count} = sourceImgs{iPatch};
                count = count + 1;
            end
        end
        p = b{randBand}(x:x+patchSizes(1,iSize)-1,y:y+patchSizes(2,iSize)-1,:);
        patches{iSize}(:,iPatch) = p(:);
    end
end
