function grabBboxers(bboxWnids,start,user,key)
% grabBboxers(bboxWnids,start,user,key)
    for i = start:length(bboxWnids)
        word = wnidToDefinition('/home/joshrule/maxlab/image-sets/image-net/images/structure_released.xml',bboxWnids{i});
        if exist(['/home/joshrule/maxlab/image-sets/image-net/images/' bboxWnids{i} '.tar'],'file') || ...
           exist(['/home/joshrule/maxlab/image-sets/image-net/images/' bboxWnids{i} '/'],'dir')
            fprintf('%d: already downloaded %s\n',i,word.words);
        else
            attempts = 0;
            while attempts <= 5
                try
                    downloadImages('/home/joshrule/maxlab/image-sets/image-net/images/',user,key,bboxWnids{i},0); % not-recursive
                    fprintf('%d: %s\n',i,word.words);
                    attempts = bitmax;
                catch err
                    attempts = attempts + 1;
                    fprintf('%d failed with: %s\n',i,getReport(err,'basic'));
                    system('rm /home/joshrule/maxlab/image-sets/image-net/images/DownloadStatus.xml');
                end
            end
        end
    end
end
