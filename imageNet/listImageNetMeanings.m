function listImageNetMeanings(wnids,srFile,outFile)
    fid = fopen(outFile,'w');
    for i = 1:length(wnids)
        w = wnidToDefinition(srFile,wnids{i});
        fprintf('%d :: %s :: %s :: %s\n',i,wnids{i},w.words,w.gloss);
        fprintf(fid,'%s :: %s :: %s\n',wnids{i},w.words,w.gloss);
    end
    fclose(fid);
