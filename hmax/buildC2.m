function [c2,labels,imageFiles] = buildC2(c2Files)
% [c2,labels,imageFiles] = buildC2(c2Files)
%
% construct c2 and labels
    allC2 = []; labels = []; imageFiles = [];
    for iClass = 1:length(c2Files)
        load(c2Files{iClass},'c2','imgFiles');
        allC2 = [allC2 c2];
        imageFiles = [imageFiles; imgFiles];
        labels = blkdiag(labels, ones(1,size(c2,2)));
        clear c2;
    end
    c2 = allC2;
end
