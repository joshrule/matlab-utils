function [shared, imgOnly, boxOnly] = existImgAndBoundingBox(imgDir,imgExtension,boxDir,boxExtension)
    imgStructs = dir([imgDir '/*.' imgExtension]);
    boxStructs = dir([boxDir '/*.' boxExtension]);
    [~,imgNames,~] = arrayfun(@(x) fileparts(x.name),imgStructs,'UniformOutput',false);
    [~,boxNames,~] = arrayfun(@(x) fileparts(x.name),boxStructs,'UniformOutput',false);

    shared = intersect(imgNames,boxNames);
    imgOnly = setdiff(imgNames,shared);
    boxOnly = setdiff(boxNames,shared);
end
