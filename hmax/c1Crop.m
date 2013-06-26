function c1Out = c1Crop(c1In,box,type,c1Scale,c1Space,rfSizes)
% c1Out = c1Crop(c1In,box,type,c1Scale,c1Space,rfSizes)
%
% Remove part of a C1 response by setting the relevant values to NaN.
% 'extractedPatches.m' avoids all NaNs when pulling out patches, meaning that
% this code could be used, for example, to prevent or require it to use areas
% occupied by a target object, given the bounding box.
%
% c1In: cell array, the C1 activation (see 'C1.m' in 'hmax' for details)
% box: double array, a 1x4 vector [y1 y2 x1 x2] indicating the area to crop.
% type: string, 'crop' or 'trim' means leave nothing but the area from 'box',
%   'box' or 'punch' means leave everything but the area from 'box'.
% c1Scale: double array, the c1Scale used to create 'c1In' (see C1.m in 'hmax')
% c1Space: double array, the c1Space used to create 'c1In'  (see C1.m in 'hmax')
% rfSizes: double array, the receptive field sizes used by initGabor when
%   creating 'c1In' (see initGabor.m in 'hmax')
%
% c1Out: cell array, the modified C1 activation
    c1Out = c1In;
    for iBand = 1:length(c1In)
        switch lower(type)
          case {'crop','trim'};
            % expand box by 1 to find edge of "bad" pixels
            [~,xmin,ymax,~] = pixelToC1(box(1,3)-1,box(1,2)+1,iBand,c1Scale, ...
              c1Space,rfSizes);
            [xmax,~,~,ymin] = pixelToC1(box(1,4)+1,box(1,1)-1,iBand,c1Scale, ...
              c1Space,rfSizes);
            % shrink box by 1 to avoid those "bad" pixels
            c1Out{iBand}(:) = NaN;
            c1Out{iBand}(ymin+1:ymax-1,xmin+1:xmax-1,:) = ...
              c1In{iBand}(ymin+1:ymax-1,xmin+1:xmax-1,:);
          case {'box','punch'}
            for iBox = 1:size(box,1)
                [xmin,~,~,ymax] = pixelToC1(box(iBox,3),box(iBox,2),iBand, ...
                  c1Scale,c1Space,rfSizes);
                [~,xmax,ymin,~] = pixelToC1(box(iBox,4),box(iBox,1),iBand, ...
                  c1Scale,c1Space,rfSizes);
                c1Out{iBand}(ymin:ymax,xmin:xmax,:) = NaN;
            end
          otherwise
            c1Out{iBand}(:) = NaN;
        end
    end
end
