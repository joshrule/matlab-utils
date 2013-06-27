function imgs = drawBoundingBox(imgList,thickness)
% imgs = drawBoundingBox(imgList,thickness)
%
% return images with bounding box drawn around target
%
% imgList: cell array of strings, each string is an absolute path for an image
% thickness: double scalar, the thickness of the border in pixels
%
% imgs: cell array of double arrays, the images with drawn bounding boxes
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
