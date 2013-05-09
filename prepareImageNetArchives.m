function prepareImageNetArchives(imgDir)
    conditionalUnpack(imgDir,listImageNetCategories(imgDir));
end

function categories = listImageNetCategories(imgDir)
   files = dir([imgDir 'n*']);
   categories = unique(regexp({files.name}','n\d+','match','once'));
   length(categories)
end

function conditionalUnpack(imgDir,categories)
    for iCategory = 1:length(categories)
        iterDir = [imgDir categories{iCategory} '/'];
        iterFile1 = [imgDir categories{iCategory} '.tar'];
        iterFile2 = [iterDir categories{iCategory} '.tar'];
        if ~exist(iterDir,'dir')
            system(['mkdir ' iterDir ';']);
        end
        if exist(iterFile1,'file') && exist(iterFile2,'file')
            system(['rm ' iterDir categories{iCategory} '.tar;']);
            fprintf('%d: removed %s\n',iCategory,iterFile1);
        elseif exist(iterFile1,'file')
            system(['mv ' iterFile1 ' ' iterFile2 ';']);
            fprintf('%d: moved %s to %s\n',iCategory,iterFile1,iterFile2);
        end
        if exist(iterFile2,'file')  
            system(['cd ' iterDir '; ' ...
                    'tar xf ' iterFile2 '; ' ...
                    'cd ' imgDir ';']);
            fprintf('%d: unpacked %s\n',iCategory,iterFile2);
        end
    end
end

