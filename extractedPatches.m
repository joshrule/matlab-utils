function [patches bandsChosen imgChosen sizesChosen locationsChosen] = extractedPatches(imgs, nPatchesPerSize, patchSizes, INTRA, EXTRA)
% [patches bandsChosen imgChosen sizesChosen locationsChosen] = extractedPatches(imgs, nPatchesPerSize, patchSizes, INTRA, EXTRA)
%
% extracts patches of C1 activations at random locations for use as S2 features.
%
% - imgs: a cell array of image filenames, the images to be mined for patches
% - nPatchesPerSize: a scalar, the number of patches to create per size
% - patchSizes: a 3 x nPatchSizes array of patch sizes. Each column should hold
%     [nRows; nCols; nOrientations]
% - INTRA: a 3-value, if > 0, use intra-bounds information, if 0, don't care,
%       if < 0, don't
% - EXTRA: a 3-value, if > 0, use extra-bounds information, if 0, don't care,
%       if < 0, don't
%
% - patches: a cell array of length nPatchSizes, with the cell at index i
%     containing an [prod(patchSizes(:,i)) nPatchesPerSize] array representing
%     the extracted patches
% - bandsChosen: an [1 nPatchesTotal] array, the band selected for each patch
% - imgChosen: an [1 nPatchesTotal] array, the image selected for each patch
% - sizesChosen: an [1 nPatchesTotal] array, the size selected for each patch

if (nargin < 5) EXTRA = -1; end;
if (nargin < 4) INTRA = -1; end;
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

% compute S1/C1 activations from images
c1r = c1rFromCells(readImages(imgs),filters,filterSizes,c1OL,c1Space,c1Scale,INCLUDEBORDERS);
GRAY =  1;
CROP = -1;
c1rBound = c1rFromCells(readImages(imgs,GRAY,CROP),filters,filterSizes,c1OL,c1Space,c1Scale,INCLUDEBORDERS);

% select patches from random C1 bands
count = 1;
for iPatch = 1:nPatchesPerSize
    for iSize = 1:nPatchSizes
        foundBand = 0;
        while (~foundBand)
            if (mod(count,100) == 0) fprintf('%d/%d\n',count,nPatchesTotal); end;
            chosenImg = ceil(rand(1)*nImgs);
            b = c1r{chosenImg};
            randBand = ceil(rand() * length(b));
            bandRows = size(b{randBand},1);
            bandCols = size(b{randBand},2);
            x = floor(rand()*(bandRows-patchSizes(1,iSize)))+1;
            y = floor(rand()*(bandCols-patchSizes(2,iSize)))+1;
            bDiff = sign(abs(b{randBand}-c1rBound{chosenImg}{randBand}));
            touchTarget = reshape(bDiff(x:x+patchSizes(1,iSize)-1,y:y+patchSizes(2,iSize)-1,:),[],1);
            if x > 0 && y > 0 &&...
              ~(INTRA > 0 && ~any(touchTarget)) &&...
              ~(INTRA < 0 && any(touchTarget)) &&...
              ~(EXTRA > 0 && ~any(~touchTarget)) &&...
              ~(EXTRA < 0 && any(~touchTarget))
                foundBand = 1;
                bandsChosen(1,count) = randBand;
                sizesChosen(1,count) = iSize;
                imgChosen{1,count} = imgs{chosenImg};
                locationsChosen(:,count) = [x; y];
                count = count + 1;
                patches{iSize}(:,iPatch) = reshape(b{randBand}(x:x+patchSizes(1,iSize)-1,y:y+patchSizes(2,iSize)-1,:),[],1);
            end
        end
    end
end
