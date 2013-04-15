function [x1o,x2o,y1o,y2o] = patchDimensionsInPixelSpace( ...
  band,x1i,x2i,y1i,y2i,c1Scale,c1Space,rfSizes,imgSizeX,imgSizeY)

    if (nargin < 10) imgSizeY = bitmax; end;
    if (nargin < 9)  imgSizeX = bitmax; end;

    [x1x1,x1x2,y1y1,y1y2] = c1ToPixel(x1i,y1i,band,c1Scale,c1Space,rfSizes, ...
                                      imgSizeX,imgSizeY);
    [x2x1,x2x2,y2y1,y2y2] = c1ToPixel(x2i,y2i,band,c1Scale,c1Space,rfSizes, ...
                                      imgSizeX,imgSizeY);
    x1o = min(x1x1,x2x1);
    x2o = max(x1x2,x2x2);
    y1o = min(y1y1,y2y1);
    y2o = max(y1y2,y2y2);
end
