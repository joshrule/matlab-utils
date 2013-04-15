function mOut = drawPatch(mIn,band,x1,x2,y1,y2,c1Scale,c1Space,rfSizes)
    [x1p,x2p,y1p,y2p] = patchDimensionsInPixelSpace(band,x1,x2,y1,y2, ...
                                                    c1Scale,c1Space,rfSizes, ...
                                                    size(mIn,2),size(mIn,1));
    mOut = mIn(y1p:y2p,x1p:x2p,:);
end