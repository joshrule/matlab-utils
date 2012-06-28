function imgs = readImages(imgList,USECROPS)
% imgs = readImages(imgList)
%
% given a cell aray of image filenames, return a cell array of image matrices
% prepared for processing by HMAX (grayscale doubles).
%
% args: imgList, a cell array of image filenames
%
% returns: imgs, a cell array of matrices representing images

if (nargin < 2) USECROPS = 0; end;

imgs = cell(1, length(imgList));
parfor i = 1:length(imgList)
    img = imread(imgList{i});
    img2 = [];
    if size(img,3) == 3
        img2 = double(rgb2gray(img));
    elseif size(img,3) == 1
        img2 = double(img);
    else
        error('images (like %s) must be grayscale or rgb\n', imgList{i});
    end

    if USECROPS && exist([imgList{i} '.mat'],'file')
        R = load([imgList{i} '.mat'],'rectangle');
        r = R.rectangle;
        imgs{i} = img2(ceil(r(2)):floor(r(2)+r(4)),ceil(r(1)):floor(r(1)+r(3)));
    else
        imgs{i} = img2;
    end
end
