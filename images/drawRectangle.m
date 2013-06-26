function m2 = drawRectangle(m1,x1,x2,y1,y2,t)
% drawRectangle(m,x,y,w,h,t)
%
% draw a rectangle in an image
%
% m1: double array, the image
% x1: scalar, the left boundary of the box to bound
% x2: scalar, the right boundary of the box to bound
% y1: scalar, the bottom boundary of the box to bound
% y2: scalar, the top boundary of the box to bound
% t: scalar, the thickness of the rectangle in pixels
%
% m2: double array, the image with the rectangle
    if (nargin < 6) t = 2; end;
    keepers = ones(size(m1),'uint8');
    keepers(max(1,y1-t+1):min(end,y2+t-1),max(1,x1-t+1):min(end,x1),:) = 0;
    keepers(max(1,y1-t+1):min(end,y2+t-1),max(1,x2):min(end,x2+t-1),:) = 0;
    keepers(max(1,y1-t+1):min(end,y1),max(1,x1-t+1):min(end,x2+t-1),:) = 0;
    keepers(max(1,y2):min(end,y2+t-1),max(1,x1-t+1):min(end,x2+t-1),:) = 0;
        m2 = keepers .* m1;
end
