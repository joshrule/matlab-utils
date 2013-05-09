function cacheC2(imgDir,outDir,categories,patchFile,maxSize,nImgs)
% cacheC2(imgDir,outDir,categories,patchFile,maxSize,nImgs)
%
% store C2 activations for a given patch set.
    [~,patchSet,~] = fileparts(patchFile);
    for iCategory = 1:length(categories)
        outFile = [outDir categories{iCategory} '.' patchSet '.c2.mat'];
        if exist(outFile,'file')
            fprintf('%d: found %s, skipping\n',iCategory,outFile);
        else
            allImgs = dir([imgDir categories{iCategory} '/*.JPEG']);
            allImgFiles = strcat(imgDir,categories{iCategory}, ...
                                 '/',{allImgs.name}');
            imgFiles = allImgFiles(randperm(length(allImgFiles), ...
                                            min(nImgs,length(allImgFiles))));
            hmaxOCV(imgFiles,patchFile,maxSize);
            c2 = xmlC22matC2(imgFiles,patchSet);
            save(outFile,'c2','imgFiles','patchFile','maxSize');
            fprintf('%d: cached %s\n',iCategory,outFile);
        end
    end
end
