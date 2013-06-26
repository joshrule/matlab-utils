function imgOut = cropImage(imgIn,annotation,CROP)
% imgOut = cropImages(imgIn,imgNames,CROP)
%
% given an image array, crop a specified portion or crop all but the specified 
%   portion.
%
% imgIn: cell array of double arrays, matrices representing images
% annotation: string, the filename of the file holding the annotation
% CROP: logical, if true, crop, if false, set box to 0 
%
% imgOut: an image array with some portion set to 0
    [aa,ab,ac] = fileparts(annotation);

    if CROP && exist(annotation,'file') && strcmp(ac,'.mat') % only box
        R = load(annotation,'rectangle');
        r = R.rectangle;
        imgOut = squeeze(imgIn(ceil(r(2)):floor(r(2)+r(4)),...
                              ceil(r(1)):floor(r(1)+r(3)),:));
    elseif CROP && exist(annotation,'file') && strcmp(ac,'.xml') % only box
        rec = VOCreadxml(annotation);
        b = rec.annotation.object(1).bndbox; % use just the first object
        resize = size(squeeze(imgIn),2)/str2num(rec.annotation.size.width);
        imgOut = squeeze( ...
          imgIn(str2num(b.ymin)*resize+1:str2num(b.ymax)*resize+1, ...
                str2num(b.xmin)*resize+1:str2num(b.xmax)*resize+1,:));
    elseif ~CROP && exist(annotation,'file') && strcmp(ac,'.mat') % exclude box
        R = load(annotation,'rectangle');
        r = R.rectangle;
        img2 = squeeze(imgIn);
        img2(ceil(r(2)):floor(r(2)+r(4)),ceil(r(1)):floor(r(1)+r(3)),:) = 0;
        imgOut = img2;
    elseif ~CROP && exist(annotation,'file') && strcmp(ac,'.xml') % exclude box
        rec = VOCreadxml(annotation);
        img2 = squeeze(imgIn);
        resize = size(img2,2)/str2num(rec.annotation.size.width);
        for iObj = 1:length(rec.annotation.object) % exclude all objects!
            b = rec.annotation.object(iObj).bndbox;
            img2(str2num(b.ymin)*resize+1:str2num(b.ymax)*resize+1, ...
                 str2num(b.xmin)*resize+1:str2num(b.xmax)*resize+1,:) = 0;
        end
        imgOut = img2;
    else
        imgOut = imgIn;
    end
end
