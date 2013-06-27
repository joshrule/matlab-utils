function [shared, imgOnly, boxOnly] = ...
  existImgAndBoundingBox(imgDir,imgExtension,boxDir,boxExtension)
% [shared, imgOnly, boxOnly] = ...
%   existImgAndBoundingBox(imgDir,imgExtension,boxDir,boxExtension)
%
% find a list of images which also have bounding boxes
%
% imgDir: string, the directory in which the images are located
% imgExtension: string, the file extension on the images
% boxDir: string, the directory in which the bounding box files are located
% boxExtension: string, the file extension on the bounding boxes
%
% shared: cell array of strings, filenames appearing in both imgDir and boxDir
% imgOnly: cell array of strings, filenames appearing in just imgDir
% boxOnly: cell array of strings, filenames appearing in just boxDir
    imgStructs = dir([imgDir '/*.' imgExtension]);
    boxStructs = dir([boxDir '/*.' boxExtension]);
    [~,imgNames,~] = arrayfun(@(x) fileparts(x.name),imgStructs,'UniformOutput',false);
    [~,boxNames,~] = arrayfun(@(x) fileparts(x.name),boxStructs,'UniformOutput',false);

    shared = intersect(imgNames,boxNames);
    imgOnly = setdiff(imgNames,shared);
    boxOnly = setdiff(boxNames,shared);
end
