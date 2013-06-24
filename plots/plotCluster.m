function plotCluster(patches,c1Space,c1Scale,rfSizes,x,y,maxSize,outFile)

    assert(x*y >= length(patches), 'not enough space for all the plots!');
    clf; f = figure();

    for i = 1:x*y
        m = uint8(resizeImage(double(imread(patches(i).img)),maxSize));
        % oops... the x and y coordinates are swapped...
        mOut = drawPatch(m,patches(i).band,patches(i).y1,patches(i).y2, ...
                         patches(i).x1,patches(i).x2,c1Scale,c1Space,rfSizes);
        subplot(x,y,i);
        imagesc(mOut);
        axis off;
    end

    print(f,'-dpng',outFile);
