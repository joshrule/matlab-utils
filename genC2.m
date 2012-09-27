function c2 = genC2(gaborSpecs,imgNames,c1bands,linPatches,patchSpecs,USEMATLAB)
% c2 = genC2(gaborSpecs,imgNames,c1bands,linPatches,patchSpecs,USEMATLAB)
% 
% give C2 responses for an image set
%
% gaborSpecs: a struct, holds information needed for creating S1 filters
% imgNames: a cell array, a list of filenames in the image set
% c1bands: a struct, holds information about bands and scales in C1
% linPatches: a cell array, the patches, before being reshaped
% patchSpecs:  a 4 x m array, 
% m = nPatchSizes and 4 rows = [rows; columns; depth; patchesPerSize]
% USEMATLAB: a boolean, if true, use HMAX-MATLAB, else use HMAX-CUDA
%
% c2, an nPatches x nImgs array, C2 responses for an image set

    if (nargin < 6) USEMATLAB = 1; end;

    [filterSizes,linFilters,c1OL,~] = initGabor(gaborSpecs.orientations,...
                                                gaborSpecs.receptiveFieldSizes,...
                                                gaborSpecs.div);

    % create square filters (S1)
    nFilters = length(filterSizes);
    for i = 1:nFilters
        iSize = filterSizes(i);
        filters{i} = reshape(linFilters(1:(iSize^2),i),iSize,iSize);
    end

    % flip patches and reshape into squares
    patchSizes = patchSpecs(1:3,:);
    nPatchSizes = size(patchSizes,2);
    iPatch = 1;
    for iSize = 1:nPatchSizes
        nOrientations = patchSizes(3,iSize);
        dimPatch = [patchSizes(1,iSize) patchSizes(2,iSize)];
        nElements = prod(dimPatch);
        for iLinearPatch = 1:size(linPatches{iSize},2)
            for iOrient = 1:nOrientations
                patchStart = 1+(iOrient-1)*nElements;
                patchStop = iOrient*nElements;
                patches{iPatch} = reshape(linPatches{iSize}(patchStart:patchStop,iLinearPatch),dimPatch);
                iPatch = iPatch+1;
            end
        end
    end

    c2 = zeros(sum(patchSpecs(4,:)),length(imgNames),'double');
    for iImg = 1:ceil(length(imgNames)/10)
        iStart = 1+(iImg-1)*10;
        iStop = min(iImg*10,length(imgNames));
        fprintf('start: %d stop: %d\n',iStart, iStop);
        imgs = readImages(imgNames(iStart:iStop));
        tooBig = false;
        for i = 1:length(imgs)
            tooBig = tooBig || max(size(imgs{i})) > 1024;
        end
        if USEMATLAB || tooBig
            c2(:,iStart:iStop) = extractC2FromCell(linFilters,filterSizes,...
                                           c1bands.c1Space,c1bands.c1Scale,...
                                           c1OL,linPatches,imgs,...
                                           size(patchSpecs,2),...
                                           patchSpecs(1:3,:),0,[],0,0);
        else
            c2(:,iStart:iStop) = hmaxCudaFun(filters,patches,imgs)';
        end
    end
end

function c2 = hmaxCudaFun(filters,patches,imgs)
    for i = 1:ceil(length(patches)/2048);
        startIn = 1+2048*(i-1);
        stopIn = min(length(patches),2048*i);
        startOut = 1+512*(i-1);
        stopOut = min(length(patches)/4,512*i);
        c2(:,startOut:stopOut) = hmaxcudanew(imgs,filters,patches(startIn:stopIn),0,1024);
    end
end
