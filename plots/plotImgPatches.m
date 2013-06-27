function plotImgPatches(imgName,patches,c1Space,c1Scale,rfSizes,maxSize,outFile)
% plotImgPatches(imgName,patches,c1Space,c1Scale,rfSizes,maxSize,outFile)
%
% draw all the patches from a patch set in a given image
%
% imgName: string, the absolute path of the image to plot
% patches: struct, a patch struct created by 'extractedPatches.m'
% c1Space: the c1Space used to extract the patch (see C1.m in 'hmax')
% c1Scale: the c1Scale used to extract the patch (see C1.m in 'hmax')
% rfSizes: the receptive field sizes used by initGabor when extracting the patch
%   (see initGabor.m in 'hmax')
% maxSize: scalar double, max length of image edges when creating the patches
% outFile: string, the absolute path to which to write the plot
    clf;
    m = uint8(resizeImage(double(imread(imgName)),maxSize));
    indexes = find(strcmp({patches.img},imgName));

    for i = 1:length(indexes)
        % oops, x and y coordinates must be swapped
        m = drawPatchInImg(m,patches(indexes(i)).band, ...
                           patches(indexes(i)).y1, ...
                           patches(indexes(i)).y2, ...
                           patches(indexes(i)).x1, ...
                           patches(indexes(i)).x2,c1Scale,c1Space,rfSizes);
    end

    imagesc(m);

    axis off;

    plot2svg(outFile,gcf);
end
