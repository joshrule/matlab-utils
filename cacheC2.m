function imgFiles = cacheC2(outFile,patchFile,maxSize,masterImgFiles)
% imgFiles = cacheC2(outFile,patchFile,maxSize,masterImgFiles)
    [~,patchSet,~] = fileparts(patchFile);
    if exist(outFile,'file')
        load(outFile,'c2','imgFiles');
        [newImgs,cacheInds] = setdiff(masterImgFiles,imgFiles);
        for i = 1:length(newImgs)
	    if length(imgFiles) > cacheInds(i)
                fprintf('    %d/%d: %s to replace %s\n',i,length(newImgs),newImgs{i},imgFiles{cacheInds(i)});
            else
                fprintf('    %d/%d: %s is new\n',i,length(newImgs),newImgs{i});
            end
        end
    else
        newImgs = masterImgFiles;
        cacheInds = 1:length(masterImgFiles);
    end
    hmaxOCV(newImgs,patchFile,maxSize);
    newC2 = xmlC22matC2(newImgs,patchSet);
    c2(:,cacheInds) = newC2;
    imgFiles = masterImgFiles;
    save(outFile,'c2','imgFiles','patchFile','maxSize');
end
