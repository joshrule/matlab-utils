function imgs = readImages(imgList,GRAY,USECROPS)
% imgs = readImages(imgList,GRAY,USECROPS)
%
% given a cell aray of image filenames, return a cell array of image matrices.
%
% imgList: a cell array of image filenames
% GRAY: a logical, if true, grayscale the images
% USECROPS: a logical, if true, use cropped images if available
%
% imgs, a cell array of matrices representing images

if (nargin < 3) USECROPS = false; end;
if (nargin < 2) GRAY = true; end;

imgs = cell(1, length(imgList));
parfor i = 1:length(imgList)
    img = imread(imgList{i});

    img2 = [];
    if GRAY && (size(img,3) == 3)
        img2 = double(rgb2gray(img));
    else
        img2 = double(img);
    end

    [fa,fb,fc] = fileparts(imgList{i});

    if USECROPS && exist([imgList{i} '.mat'],'file')
        R = load([imgList{i} '.mat'],'rectangle');
        r = R.rectangle;
        imgs{i} = squeeze(img2(ceil(r(2)):floor(r(2)+r(4)),...
                               ceil(r(1)):floor(r(1)+r(3)),:));
    elseif USECROPS && exist(fullfile(fa,[fb '.xml']),'file')
        fprintf('%d ',i);
        rec = VOCreadxml(fullfile(fa,[fb,'.xml']));
        b = rec.annotation.object.bndbox;
        imgs{i} = squeeze(img2(str2num(b.ymin)+1:str2num(b.ymax)+1,str2num(b.xmin)+1:str2num(b.xmax)+1,:));
    else
        imgs{i} = img2;
    end
end
