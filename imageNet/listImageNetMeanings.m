function listImageNetMeanings(wnids,srFile,outFile)
    for i = 1:length(wnids)
        w = wnidToDefinition(srFile,wnids{i});
        fprintf('%d :: %s :: %s :: %s\n',i,wnids{i},w.words,w.gloss);
        words{i} = w.words;
        glosses{i} = w.gloss;
    end
    wnidTable = table(wnids,words',glosses','VariableNames', {'wnid','word','gloss'});
    writetable(wnidTable, outFile, 'WriteVariableNames', true, 'Delimiter',',', 'QuoteStrings',true);
