function paths = lsCell(directory, extensions)
% paths = lsCell(directory, extensions)
%
% gives a cell array of path for images in the given directory

imgsByExt = cellfun(@(x) dir(fullfile(directory, ['*.' x])), extensions,'UniformOutput',0);

imgList = [];
for iExt = 1:length(imgsByExt)
    imgList = [imgList imgsByExt{iExt}'];
end

paths = arrayfun(@(x) fullfile(directory,x.name),imgList,'UniformOutput',0);
