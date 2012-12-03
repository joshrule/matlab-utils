function imgs = drawBoundingBox(imgList,thickness)
% imgs = drawBoundingBox(imgList,color)
%
% return images with bounding box drawn around target
%
% imgList: a cell array, each entry is an absolute path for an image
% thickness: a scalar, the thickness of the border
%
% imgs: a cell array, the images with drawn bounding boxes

    rawImgs = readImages(imgList);

    for i = 1:length(imgList)
        imgs{i} = squeeze(rawImgs{i});
        [fa,fb,fc] = fileparts(imgList{i});

        if exist(fullfile(fa,[fb '.xml']),'file')
            rec = VOCreadxml(fullfile(fa,[fb,'.xml']));
            resize = size(imgs{i},2)/str2num(rec.annotation.size.width);
            for iObj = 1:length(rec.annotation.object) % exclude all objects!
                b = rec.annotation.object(iObj).bndbox;
                y1 = str2num(b.xmin)*resize+1;
                x1 = str2num(b.ymin)*resize+1;
                y2 = str2num(b.xmax)*resize+1;
                x2 = str2num(b.ymax)*resize+1;
                imgs{i} = drawRectangle(imgs{i},x1,x2,y1,y2,thickness);
            end
            fprintf('%d: %s\n',i,[fb fc]);
        end
    end
end

function m2 = drawRectangle(m1,x1,x2,y1,y2,t)
% drawRectangle(m,x,y,w,h,t)
%
% draw a rectangle in an image
%
% m1: a numeric array, the image
% x1: a scalar, the left boundary of the box to bound
% x2: a scalar, the right boundary of the box to bound
% y1: a scalar, the bottom boundary of the box to bound
% y2: a scalar, the top boundary of the box to bound
% t: a scalar, the thickness of the rectangle
%
% m2: a numeric array, the image with the rectangle

    keepers = ones(size(m1));
    keepers(max(1,x1-t+1):min(end,x2+t-1),max(1,y1-t+1):min(end,y1)) = 0;
    keepers(max(1,x1-t+1):min(end,x2+t-1),max(1,y2):min(end,y2+t-1)) = 0;
    keepers(max(1,x1-t+1):min(end,x1),max(1,y1-t+1):min(end,y2+t-1)) = 0;
    keepers(max(1,x2):min(end,x2+t-1),max(1,y1-t+1):min(end,y2+t-1)) = 0;
    m2 = keepers .* m1;
end
