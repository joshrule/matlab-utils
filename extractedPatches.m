function [patches,bands,imgs,sizes,locations] = extractedPatches(c1r,patchSizes)
% [patches,bands,imgs,sizes,locations] = extractedPatches(c1r,patchSizes)
%
% extract patches of C1 activations at random locations for use as S2 features.
%
% - c1r: a cell array of c1 responses, each c1r{i} is a separate image
% - patchSizes: a 4 x nPatchSizes array of patch sizes. Each column should hold
%     [nRows; nCols; nOrientations; nPatches]
%
% - patches: a cell array of length nPatchSizes, with the cell at index i
%     containing an [prod(patchSizes(:,i)) nPatchesPerSize] array representing
%     the extracted patches
% - bands: an [1 sum(patchSizes(4,:))] array, band selected for each patch
% - imgs: an [1 sum(patchSizes(4,:))] array, image selected for each patch
% - sizes: an [1 sum(patchSizes(4,:))] array, size selected for each patch
% - locations: an [2 sum(patchSizes(4,:))] array, location for each patch
%     coordinates reported are in the C1-space of the selected band

    if (nargin < 2) patchSizes = [2:2:8;2:2:8;4*ones(1,4);100*ones(1,4)]; end;
    nPatchSizes = size(patchSizes,2);
    nImgs = length(c1r);

    for iSize = 1:nPatchSizes
        for iPatch = 1:patchSizes(4,iSize)
            searchingForPatch = 1;
            while searchingForPatch
                chosenImg = ceil(rand(1)*nImgs);
                b = c1r{chosenImg};
                randBand = ceil(rand() * length(b));
                [bandRows bandCols ~] = size(b{randBand});
                x1 = floor(rand()*(bandRows-patchSizes(1,iSize)))+1;
                y1 = floor(rand()*(bandCols-patchSizes(2,iSize)))+1;
                x2 = x1+patchSizes(1,iSize)-1;
                y2 = y1+patchSizes(2,iSize)-1;
                if x1 > 0 && y1 > 0 && x2 <= bandRows && y2 <= bandCols
                    searchingForPatch = 0;
                    idx = sum(patchSizes(4,1:iSize-1))+iPatch;
                    bands(idx) = randBand;
                    imgs(idx) = chosenImg;
                    sizes(idx) = iSize;
                    locations(:,idx) = [x1; y1];
                    patches{iSize}(:,iPatch) = ...
                      reshape(b{randBand}(x1:x2,y1:y2,:),[],1);
                end
            end
        end
    end
end
