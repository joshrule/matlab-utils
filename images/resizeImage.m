function imgOut = resizeSize(imgIn,minSize)
% imgOut = resizeSize(imgIn,minSize)
%
% transform an image to be no smaller than [minSize minSize] without altering its
%   aspect ratio, but with one dimension equal to minSize.
%
% imgIn: an image array of any size
% minSize: a scalar, min(size(image)) == minSize
%
% imgOut: an image array no larger than [maxSize maxSize], but preserving the
%   aspect ratio of the original image
    imSize = size(imgIn);
    imgOut = double(imresize(imgIn,minSize/min(imSize(1:2))));
end
