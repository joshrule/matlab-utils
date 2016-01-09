function [c1 c2 r1 r2] = c1ToPixel(c,r,band,c1Scale,c1Space,rfSizes,imgSizeC,imgSizeR)
% [c1 c2 r1 r2] = c1ToPixel(c,r,band,c1Scale,c1Space,rfSizes,imgSizeC,imgSizeR)
%
% translate a point in C1-space back to the area in pixel-space generating it.
% The actual size of the image is optional, but should be included for the best
% accuracy. Otherwise, all pooling operations will be calculated as if the image
% were perfectly sized such that there were no partial pooling neighborhoods.
%
% c: scalar double, the column in which the point appears in C1-space
% r: scalar double, the row in which the point appears in C1-space
% band: scalar double, the C1-band in which the point appears (see 'C1.m' in 'hmax')
% c1Scale: double array, the c1Scale of the C1 activation (see C1.m in 'hmax')
% c1Space: double array, the c1Space of the C1 activation  (see C1.m in 'hmax')
% rfSizes: double array, the receptive field sizes used by initGabor for the C1
%   activation (see initGabor.m in 'hmax')
% imgSizeC: scalar double, the number of columns in the image, optional
% imgSizeR: scalar double, the number of rows in the image, optional
%
% c1,c2,r1,r2: scalar doubles, the minimum and maximum of the columns and rows
%   in pixel-space generating the point [r,c] in C1-space.
    if (nargin < 8) imgSizeR = bitmax; end;
    if (nargin < 7) imgSizeC = bitmax; end;

    if isnan(c) || isnan(r)
        c1 = false; c2 = false; r1 = false; r2 = false;
    else
        % reverse C1 (maxFilter)
        poolSize = c1Space(band);
        halfPool = poolSize/2;
        s1CMin = (c-1)*halfPool+1; % 1:halfpool:s1Cols
        s1RMin = (r-1)*halfPool+1; % 1:halfpool:s1Rows
        s1CMax = s1CMin+poolSize-1;
        s1RMax = s1RMin+poolSize-1;

        % reverse S1 (conv2)
        halfMaxSize = max(rfSizes(c1Scale(band):c1Scale(band+1)-1))/2;
        c1 = max(min(s1CMin-(ceil(halfMaxSize)-1), ...
                     s1CMax-(ceil(halfMaxSize)-1)), ...
                 1);
        c2 = min(max(s1CMin+floor(halfMaxSize), ...
                     s1CMax+floor(halfMaxSize)), ...
                 imgSizeC);
        r1 = max(min(s1RMin-(ceil(halfMaxSize)-1), ...
                     s1RMax-(ceil(halfMaxSize)-1)), ...
                 1);
        r2 = min(max(s1RMin+floor(halfMaxSize), ...
                     s1RMax+floor(halfMaxSize)), ...
                 imgSizeR);
    end
end
