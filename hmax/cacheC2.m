function imgFiles = cacheC2(outFile,patchFile,maxSize,masterImgFiles,hmaxHome)
% imgFiles = cacheC2(outFile,patchFile,maxSize,masterImgFiles)
    [~,patchSet,~] = fileparts(patchFile);
    if exist(outFile,'file')
        load(outFile,'c2','imgFiles');
        [newImgs,cacheInds] = setdiff(masterImgFiles,imgFiles);
        for i = 1:length(newImgs)
            fprintf('    %d/%d: %s to replace %s\n',i,length(newImgs),newImgs{i},imgFiles{cacheInds(i)});
        end
    else
        newImgs = masterImgFiles;
        cacheInds = 1:length(masterImgFiles);
    end
    hmaxOCV(newImgs,patchFile,hmaxHome,maxSize);
    c2 = xmlC22matC2(masterImgFiles,patchSet);
    imgFiles = masterImgFiles;
    save(outFile,'c2','imgFiles','patchFile','maxSize');
end
