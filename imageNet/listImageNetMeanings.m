function listImageNetMeanings(wnids,srFile,outFile)
    fid = fopen(outFile,'w');
    for i = 1:length(wnids)
        w = wnidToDefinition(srFile,wnids{i});
        fprintf('%d :: %s :: %s\n',i,w.words,w.gloss);
        fprintf(fid,'%s :: %s\n',w.words,w.gloss);
    end
    fclose(fid);
