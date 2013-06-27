function mOut = drawPatch(mIn,band,x1,x2,y1,y2,c1Scale,c1Space,rfSizes)
% mOut = drawPatch(mIn,band,x1,x2,y1,y2,c1Scale,c1Space,rfSizes)
%
% given relevant information about an S2 patch, draw the image chunk from whence
% it originated.
%
% mIn: double array, the original image
% band: scalar, the C1 band from which the patch was taken
% x1: scalar, the left boundary of the patch in 'band'
% x2: scalar, the right boundary of the patch in 'band'
% y1: scalar, the bottom boundary of the patch in 'band'
% y2: scalar, the top boundary of the patch in 'band'
% c1Scale: the c1Scale used to extract the patch (see C1.m in 'hmax')
% c1Space: the c1Space used to extract the patch (see C1.m in 'hmax')
% rfSizes: the receptive field sizes used by initGabor when extracting the patch
%   (see initGabor.m in 'hmax')
%
% mOut: double array, the patch
    [x1p,x2p,y1p,y2p] = patchDimensionsInPixelSpace(band,x1,x2,y1,y2, ...
                                                    c1Scale,c1Space,rfSizes, ...
                                                    size(mIn,2),size(mIn,1));
    mOut = mIn(y1p:y2p,x1p:x2p,:);
end
