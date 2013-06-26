function imgFiles = cacheC2(outFile,patchFile,maxSize,masterImgFiles,hmaxHome)
% imgFiles = cacheC2(outFile,patchFile,maxSize,masterImgFiles,hmaxHome)
%
% given a set of images and a patch set, cache the C2 activations to disk
%
% outFile: string, where to write the activations on disk
% patchFile: string, the XML patch set to use with HMAX-OCV
% maxSize: scalar double, the longest allowable single edge in the image
% masterImgFiles: cell array of strings, the images to cache
% hmaxHome: string, the directory in which to find HMAX-OCV
%
% imgFiles: cell array of strings, the cached images
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
