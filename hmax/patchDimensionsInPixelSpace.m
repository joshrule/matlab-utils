function [c1,c2,r1,r2] = patchDimensionsInPixelSpace( ...
  band,p1c,p2c,p1r,p2r,c1Scale,c1Space,rfSizes,imgSizeC,imgSizeR)
% [x1o,x2o,y1o,y2o] = patchDimensionsInPixelSpace( ...
%   band,p1c,p2c,p1r,p2r,c1Scale,c1Space,rfSizes,imgSizeC,imgSizeR)
%
% Given information about a patch, return the area in pixel space which
% contributes to it.
%
% band: scalar double, the C1-band of interest (see 'C1.m' in 'hmax')
% x1i,x2i,y1i,y2i: scalar doubles, the four corners of the patch in C1-space
% c1Scale: double array, the c1Scale of the C1 activation (see C1.m in 'hmax')
% c1Space: double array, the c1Space of the C1 activation  (see C1.m in 'hmax')
% rfSizes: double array, the receptive field sizes used by initGabor for the C1
%   activation (see initGabor.m in 'hmax')
% imgSizeC: scalar double, the number of columns in the image, optional
% imgSizeR: scalar double, the number of rows in the image, optional
%
% c1,c2,r1,r2: scalar doubles, the four corners of the patch in pixel-space
    if (nargin < 10) imgSizeR = bitmax; end;
    if (nargin < 9)  imgSizeC = bitmax; end;

    [p1c1,p1c2,p1r1,p1r2] = c1ToPixel(p1c,p1r,band,c1Scale,c1Space,rfSizes, ...
                                      imgSizeC,imgSizeR);
    [p2c1,p2c2,p2r1,p2r2] = c1ToPixel(p2c,p2r,band,c1Scale,c1Space,rfSizes, ...
                                      imgSizeC,imgSizeR);
    c1 = min(p1c1,p2c1);
    c2 = max(p1c2,p2c2);
    r1 = min(p1r1,p2r1);
    r2 = max(p1r2,p2r2);
end
