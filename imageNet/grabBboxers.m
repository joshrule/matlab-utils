function downloadImageNetSynsets(wnids,user,key,structureReleased,imgDir)
% downloadImageNetSynsets(wnids,user,key)
%
% download ImageNet synsets from the ImageNet server
%
% wnids: cell array of strings, the WordNetIDs for the synsets to download
% user: the username of the ImageNet account to use for downloading
% key: the password of the ImageNet account to use for downloading
% structureReleased: string, the filename of the xml file from ImageNet holding
%   all the structure information about the current ImageNet release.
% imgDir: string, the directory in which to put the downloaded synsets
    for i = 1:length(wnids)
        word = wnidToDefinition(structureReleased,wnids{i});
        if exist([imgDir wnids{i} '.tar'],'file') || ...
           exist([imgDir wnids{i} '/'],'dir')
            fprintf('%d: already downloaded %s\n',i,word.words);
        else
            attempts = 0;
            while attempts <= 5
                try
                    downloadImages(imgDir,user,key,wnids{i},0); % not-recursive
                    fprintf('%d: %s\n',i,word.words);
                    attempts = bitmax;
                catch err
                    attempts = attempts + 1;
                    fprintf('%d failed with: %s\n',i,getReport(err,'basic'));
                    system(['rm ' imgDir 'DownloadStatus.xml');
                end
            end
        end
    end
end
