function ps = extractedPatches(c1r,patchSizes,gradThreshold,corrThreshold)
% [patches,bands,imgs,sizes,locations] = extractedPatches(c1r,patchSizes)
%
% extract patches of C1 activations at random locations for use as S2 features.
%
% - c1r: a cell array of c1 responses, each c1r{i} is a separate image and NaNs
%     are considered "cropped" or "punched-out" areas of the image.
% - patchSizes: a 4 x nPatchSizes array of patch sizes. Each column should hold
%     [nRows; nCols; nOrientations; nPatches]
% - gradThreshold: a scalar, determines average per-pixel gradient energy
%     required. It defaults to 10^-3, the approximate lower threshold found in
%     one set of our kmeans universal patches in 2012.
% - corrThreshold: a scalar, determines max correlation allowed between patches
%
% - patches: a cell array of length nPatchSizes, with the cell at index i
%     containing an [prod(patchSizes(:,i)) nPatchesPerSize] array of patches
% - bands: an [1 sum(patchSizes(4,:))] array, band selected for each patch
% - imgs: an [1 sum(patchSizes(4,:))] array, image selected for each patch
% - sizes: an [1 sum(patchSizes(4,:))] array, size selected for each patch
% - locations: an [2 sum(patchSizes(4,:))] array, C1-location for each patch

    if (nargin < 4) corrThreshold = 0.8; end;
    if (nargin < 3) gradThreshold = 10^-3; end;
    if (nargin < 2) patchSizes = [2:2:8;2:2:8;4*ones(1,4);100*ones(1,4)]; end;
    nImgs = length(c1r);
    nPatchSizes = size(patchSizes,2);
%   ps = struct('bands',[],'imgs',[],'sizes',[],...
%     'locations',[],'patches',cell(1,8));

    for iSize = 1:nPatchSizes
        ps.patches{iSize} = [];
        for iPatch = 1:patchSizes(4,iSize)
            huntingPatch = 1;
            while huntingPatch
                chosenImg = randi(nImgs);
                b = c1r{chosenImg};
                randBand = randi(length(b));
                [bandRows bandCols ~] = size(b{randBand});
                r1 = floor(rand*bandRows-patchSizes(1,iSize))+1;
                c1 = floor(rand*bandCols-patchSizes(2,iSize))+1;
                r2 = r1+patchSizes(1,iSize)-1;
                c2 = c1+patchSizes(2,iSize)-1;
                if r1>0 && c1>0 && r2 <= bandRows && c2 <= bandCols
                    newPatch = b{randBand}(r1:r2,c1:c2,:);
                    huntingPatch = testPatch(ps.patches{iSize},newPatch,...
                      gradThreshold,corrThreshold); % if invalid, loops again
                    idx = sum(patchSizes(4,1:iSize-1))+iPatch;
                    ps.bands(idx) = randBand;
                    ps.imgs(idx) = chosenImg;
                    ps.sizes(idx,:) = patchSizes(1:3,iSize);
                    ps.locations(idx,:) = [r1 c1];
                    ps.patches{iSize}(:,iPatch) = reshape(newPatch,[],1);
                end
            end
        end
    end
end

function patchIsValid = testPatch(patches,patch,gradThreshold,corrThreshold)
    avoidsCrop = isempty(find(isnan(patch(:))));
    nonZero = max(patch(:)) >= 10^-10;
    highContrast = mean(reshape(abs(gradient(patch)),1,[])) >= gradThreshold;
    lowCorrelation = ~isempty(patches) && ...
      max(corr(patches,patch(:))) < corrThreshold;
    patchIsValid = avoidsCrop && nonZero && highContrast && lowCorrelation;
end
