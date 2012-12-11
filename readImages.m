function imgs = readImages(imgList,GRAY,CROP,maxSize)
% imgs = readImages(imgList,GRAY,CROP)
%
% given a cell aray of image filenames, return a cell array of image matrices.
%
% imgList: a cell array of image filenames
% GRAY: a logical, if true, grayscale the images
% CROP: an int, if > 0, crop, if 0, do nothing, if < 0, cropped region = 0
% maxSize: a scalar, max(size(image)) < maxSize
%
% imgs, a cell array of matrices representing images

if (nargin < 3) CROP = 0; end;
if (nargin < 2) GRAY = 1; end;

imgs = cell(1, length(imgList));
for i = 1:length(imgList)
    img = imread(imgList{i});

    img2 = [];
    if GRAY && (size(img,3) == 3)
        img2 = double(rgb2gray(img));
    else
        img2 = double(img);
    end

    if (nargin == 4) && max(size(img2)) > maxSize
        img3 = imresize(img2,maxSize/max(size(img2)));
    else
        img3 = img2;
    end

    [fa,fb,fc] = fileparts(imgList{i});

    if CROP > 0 && exist([imgList{i} '.mat'],'file') % only box
        R = load([imgList{i} '.mat'],'rectangle');
        r = R.rectangle;
        imgs{i} = squeeze(img3(ceil(r(2)):floor(r(2)+r(4)),...
                               ceil(r(1)):floor(r(1)+r(3)),:));
    elseif CROP > 0 && exist(fullfile(fa,[fb '.xml']),'file') % only box
        rec = VOCreadxml(fullfile(fa,[fb,'.xml']));
        b = rec.annotation.object(1).bndbox; % use just the first object
        resize = size(squeeze(img3),2)/str2num(rec.annotation.size.width);
        imgs{i} = squeeze(img3(str2num(b.ymin)*resize+1:str2num(b.ymax)*resize+1,str2num(b.xmin)*resize+1:str2num(b.xmax)*resize+1,:));
    elseif CROP < 0 && exist([imgList{i} '.mat'],'file') % exclude box
        R = load([imgList{i} '.mat'],'rectangle');
        r = R.rectangle;
        img4 = squeeze(img3);
        img4(ceil(r(2)):floor(r(2)+r(4)),ceil(r(1)):floor(r(1)+r(3)),:) = 0;
        imgs{i} = img4;
    elseif CROP < 0 && exist(fullfile(fa,[fb '.xml']),'file') % exclude box
        rec = VOCreadxml(fullfile(fa,[fb,'.xml']));
        img4 = squeeze(img3);
        resize = size(img4,2)/str2num(rec.annotation.size.width);
        for iObj = 1:length(rec.annotation.object) % exclude all objects!
            b = rec.annotation.object(iObj).bndbox;
            img4(str2num(b.ymin)*resize+1:str2num(b.ymax)*resize+1,str2num(b.xmin)*resize+1:str2num(b.xmax)*resize+1,:) = 0;
        end
        imgs{i} = img4;
    else
        imgs{i} = img3;
    end
end
