function [cachedCategories,imgList] = cacheWithoutDuplicates(imgDir,outDir,categories,patchFile,maxSize,nImgs,hmaxHome,imgListIn)
% [cachedCategories,imgList] = cacheWithoutDuplicates(imgDir,outDir,categories,patchFile,maxSize,nImgs,hmaxHome,imgListIn)
%
% store C2 activations for a given patch set.
    [~,patchSet,~] = fileparts(patchFile);
    if (nargin < 7) 
        imgList = {};
    else
        imgList = imgListIn;
    end
    cachedCategories = {};
    for iCategory = 1:length(categories)
        catDir = [imgDir categories{iCategory} '/'];
        outFile = [outDir categories{iCategory} '.' patchSet '.c2.mat'];

        imgFiles = [];
        if exist(outFile,'file')
            load(outFile,'imgFiles');
        end
        [count,newImgFiles] = duplicateFreeImgFiles(imgList,catDir,nImgs,imgFiles);

        if isequal(imgFiles,newImgFiles) && count == nImgs
            imgList = {imgList{:} imgFiles{:}};
            cachedCategories = [cachedCategories categories{iCategory}];
            fprintf('%d (%d): found %s, no duplicates\n',iCategory,length(imgList),outFile);
        elseif count == nImgs
            cachedFiles = cacheC2(outFile,patchFile,maxSize,newImgFiles,hmaxHome);
            imgList = {imgList{:} cachedFiles{:}};
            cachedCategories = [cachedCategories categories{iCategory}];
            fprintf('%d: cached %s, new cache\n',iCategory,outFile);
        elseif (count < nImgs) && exist(outFile,'file')
            delete(outFile);
            fprintf('%d: removed %s, too few images (%d < %d)\n', ...
                    iCategory,outFile,count,nImgs);
        elseif (count < nImgs)
            fprintf('%d: skipped %s, too few images (%d < %d)\n', ...
                    iCategory,outFile,count,nImgs);
        else
            fprintf('%d: Undefined behavior!\n',iCategory);
        end
    end
end

function [count,imgFilesOut] = duplicateFreeImgFiles(imgList,catDir,nImgs,imgFilesIn)
    allImgs = dir([catDir '*.JPEG']);
    allImgFiles = [imgFilesIn; ...
                        setdiff(strcat(catDir, {allImgs.name}'),imgFilesIn)];
    count = 1;
    iImg = 1;
    imgFilesOut = {};
    duplicates = zeros(nImgs,1);
    while (count <= nImgs) && (iImg <= length(allImgFiles))
        currFiles = {imgList{:} imgFilesOut{:}};
        fid = fopen('~/tmp.txt','w'); fprintf(fid,'%s\n',currFiles{:}); fclose(fid);
        [~,output] = system(['xargs -a ~/tmp.txt -n 4096 diff -s --from-file=' ...
                             allImgFiles{iImg} ' | grep identical']);
        notDuplicate = isempty(strfind(output,'identical'));
        if notDuplicate && iImg <= nImgs
            imgFilesOut{iImg} = allImgFiles{iImg};
            count = count+1;
        elseif notDuplicate && iImg > nImgs
            toReplace = find(duplicates,1);
            imgFilesOut{toReplace} = allImgFiles{iImg};
            count = count+1;
            duplicates(toReplace) = 0;
        elseif ~notDuplicate && iImg <= nImgs
            duplicates(iImg) = 1;
        end
        iImg = iImg+1;
    end
    if count < nImgs
        imgFilesOut = [];
    end
    imgFilesOut = imgFilesOut';
    count = count-1;
end
