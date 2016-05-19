function prepareImageNetArchives(imgDir)
% prepareImageNetArchives(imgDir)
%
% Unpack any downloaded but as yet unpacked ImageNet synset archives in the
% given directory. The archives are the *.tar files originally provided by
% ImageNet.
%
% imgDir: string, the directory to search for ImageNet synset archives
    files = dir([imgDir 'n*']);
    categories = listImageNetCategories({files.name});
    for iCategory = 1:length(categories)
        iterDir = [imgDir categories{iCategory} '/'];
        iterFile1 = [imgDir categories{iCategory} '.tar'];
        iterFile2 = [iterDir categories{iCategory} '.tar'];
        if ~exist(iterDir,'dir')
            system(['mkdir ' iterDir ';']);
        end
        if exist(iterFile1,'file') && exist(iterFile2,'file')
            system(['rm ' iterFile1]);
            fprintf('%d: removed %s\n',iCategory,iterFile1);
        elseif exist(iterFile1,'file')
            system(['mv ' iterFile1 ' ' iterFile2 ';']);
            fprintf('%d: moved %s to %s\n',iCategory,iterFile1,iterFile2);
        end
        if exist(iterFile2,'file') 
            if (length(dir([iterDir categories{iCategory} '*.JPEG'])) == 0)
                system(['cd ' iterDir '; ' ...
                        'tar xf ' iterFile2 '; ' ...
                        'rm ' iterFile2 '; ' ...
                        'cd ' imgDir ';']);
                fprintf('%d: unpacked %s\n',iCategory,iterFile2);
            else
                system(['cd ' iterDir '; ' ...
                        'rm ' iterFile2 '; ' ...
                        'cd ' imgDir ';']);
                fprintf('%d: no work\n',iCategory);
            end
        end
    end
end

