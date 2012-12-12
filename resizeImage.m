function imgOut = capSize(imgIn,maxSize)
% imgOut = capSize(imgIn,maxSize)
%
% force an image to be no larger than [maxSize maxSize]
%
% imgIn: an image array of any size
% maxSize: a scalar, max(size(image)) < maxSize
%
% imgOut: an image array no larger than [maxSize maxSize]

imgOut = double(imresize(imgIn,min(1,maxSize/max(size(imgIn)))));
