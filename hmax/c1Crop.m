function c1Out = c1Crop(c1In,box,type,c1Scale,c1Space,rfSizes)
% c1Out = c1Crop(c1In,box,type,c1Scale,c1Space,rfSizes)

    c1Out = c1In;
    for iBand = 1:length(c1In)
        switch lower(type)
          case {'crop','trim'};
            % expand box by 1 to find edge of "bad" pixels
            [~,xmin,ymax,~] = pixelToC1(box(1,3)-1,box(1,2)+1,iBand,c1Scale,c1Space,rfSizes);
            [xmax,~,~,ymin] = pixelToC1(box(1,4)+1,box(1,1)-1,iBand,c1Scale,c1Space,rfSizes);
            % shrink box by 1 to avoid those "bad" pixels
            c1Out{iBand}(:) = NaN;
            c1Out{iBand}(ymin+1:ymax-1,xmin+1:xmax-1,:) = c1In{iBand}(ymin+1:ymax-1,xmin+1:xmax-1,:);
          case {'box','punch'}
            for iBox = 1:size(box,1)
                [xmin,~,~,ymax] = pixelToC1(box(iBox,3),box(iBox,2),iBand,c1Scale,c1Space,rfSizes);
                [~,xmax,ymin,~] = pixelToC1(box(iBox,4),box(iBox,1),iBand,c1Scale,c1Space,rfSizes);
                c1Out{iBand}(ymin:ymax,xmin:xmax,:) = NaN;
            end
          otherwise
            c1Out{iBand}(:) = NaN;
        end
    end
end
