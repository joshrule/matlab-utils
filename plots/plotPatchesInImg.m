function plotPatchesInImg(imgName,patches,c1Space,c1Scale,rfSizes,maxSize,outFile)

    clf; f = figure();
    m = uint8(resizeImage(double(imread(imgName)),maxSize));
    indexes = find(strcmp({patches.img},imgName));

    for i = 1:length(indexes)
        % oops... the x and y coordinates are swapped...
        m = drawPatchInImg(m,patches(indexes(i)).band, ...
                           patches(indexes(i)).y1, ...
                           patches(indexes(i)).y2, ...
                           patches(indexes(i)).x1, ...
                           patches(indexes(i)).x2,c1Scale,c1Space,rfSizes);
    end

    imagesc(m);
    axis off;
    print(f,'-dpng',outFile);
