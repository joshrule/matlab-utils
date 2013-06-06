function cacheC2(imgDir,outDir,categories,patchFile,maxSize,nImgs,imgNames)
% cacheC2(imgDir,outDir,categories,patchFile,maxSize,nImgs)
%
% store C2 activations for a given patch set.

    if (nargin < 7) imgNames = cell(length(categories),1); end;

    [~,patchSet,~] = fileparts(patchFile);
    for iCategory = 1:length(categories)
        outFile = [outDir categories{iCategory} '.' patchSet '.c2.mat'];
        if exist(outFile,'file')
            fprintf('%d: found %s, skipping\n',iCategory,outFile);
        else
            if isempty(imgNames{iCategory})
                allImgs = dir([imgDir categories{iCategory} '/*.JPEG']);
                allImgFiles = strcat(imgDir,categories{iCategory}, ...
                                     '/',{allImgs.name}');
                imgNames{iCategory} = allImgFiles(randperm(length(allImgFiles), ...
                                                           min(nImgs,length(allImgFiles))));
            end
            hmaxOCV(imgNames{iCategory},patchFile,maxSize);
            c2 = xmlC22matC2(imgNames{iCategory},patchSet);
            imgFiles = imgNames{iCategory};
            save(outFile,'c2','imgFiles','patchFile','maxSize');
            fprintf('%d: cached %s\n',iCategory,outFile);
        end
    end
end
