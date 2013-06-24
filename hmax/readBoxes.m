function boxes = readBoxes(imgNames,boxNames)
% boxes = readBoxes(imgNames,boxNames)
%
% given an image array, crop out a specified portion
%
% imgNames: cell array, filenames of the images
% boxNames: cell array, filenames of the annotations
%
% boxes: cell array, nBox x 4 matrices of bounding boxes, [rmin rmax cmin cmax]


    for iImg = 1:length(boxNames)
        [aa,ab,ac] = fileparts(boxNames{iImg});
        if exist(boxNames{iImg},'file') && strcmp(ac,'.mat')
            R = load(boxNames{iImg},'rectangle');
            r = R.rectangle;
            boxes{iImg} = [ceil(r(2)) floor(r(2)+r(4)),...
                           ceil(r(1)) floor(r(1)+r(3))];
        elseif exist(boxNames{iImg},'file') && strcmp(ac,'.xml') && exist(imgNames{iImg},'file')
            rec = VOCreadxml(boxNames{iImg});
            imgInfo = imfinfo(imgNames{iImg}); % "necessary" kludge
            resize = imgInfo.Width/str2num(rec.annotation.size.width);
            for iBox = 1:length(rec.annotation.object) % exclude all objects!
                b = rec.annotation.object(iBox).bndbox;
                boxes{iImg}(iBox,:) = [str2num(b.ymin)*resize+1,...
                                       str2num(b.ymax)*resize+1,...
                                       str2num(b.xmin)*resize+1,...
                                       str2num(b.xmax)*resize+1];
            end
        else % give back a nonsense box
            boxes{iImg} = [NaN NaN NaN NaN];
        end
    end
end
