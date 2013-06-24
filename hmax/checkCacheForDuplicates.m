function imgList = checkCacheForDuplicates(inDir,outDir,patchSet)

    files = dir([inDir 'n*.' patchSet '.c2.mat']);
    fileStems = {files.name}';
    fileNames = strcat(inDir,fileStems);

    imgList = {};
    for iCat = 1:length(fileNames)
        if (mod(iCat,100) == 0) fprintf('%d/%d\n',iCat,length(fileNames)); end;
        load(fileNames{iCat},'imgFiles');
        last = length(imgList);
        imgList(last+1:last+length(imgFiles)) = imgFiles;
    end

    parfor iImg = 1:length(imgList)
        a = tic;
        dupCheck(imgList,iImg,outDir);
        fprintf('%d/%d: %.3f\n',iImg,length(imgList),toc(a));
    end
end

function dupCheck(imgList,iImg,outDir)
    inName = ['~/cacheImageNames/' num2str(iImg) '.txt'];
    fid = fopen(inName,'a'); fprintf(fid,'%s\n',imgList{iImg:end}); fclose(fid);
    system(['xargs -a ' inName ' -n 4096 diff -s --from-file=' imgList{iImg} ' | grep identical > ' outDir num2str(iImg) '.txt']);
    delete(inName);
end
