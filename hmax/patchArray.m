function patchArray = patchArray(patchStruct,imgNames)
% patchArray = patchArray(patchStruct,imgNames)
%
% convert a standard patch struct into an array for the Efros algorithm

    patches = patchStruct.patches{1}; % TODO: hack for single sizes!
    sizes = patchStruct.sizes;
    imgs = patchStruct.imgs;
    locations = patchStruct.locations;
    bands = patchStruct.bands;
    nPatches = size(patches,2);

    for iPatch = 1:nPatches
        patchArray(iPatch).patch = patches(:,iPatch);
        patchArray(iPatch).img = imgNames{imgs(iPatch)};
        patchArray(iPatch).size.nrows = sizes(iPatch,1);
        patchArray(iPatch).size.ncols = sizes(iPatch,2);
        patchArray(iPatch).size.nOrientations = sizes(iPatch,3);
        patchArray(iPatch).band = bands(iPatch);
        patchArray(iPatch).y1 = locations(iPatch,1);
        patchArray(iPatch).y2 = locations(iPatch,1)+sizes(iPatch,1)-1;
        patchArray(iPatch).x1 = locations(iPatch,2);
        patchArray(iPatch).x2 = locations(iPatch,2)+sizes(iPatch,2)-1;
    end
end
