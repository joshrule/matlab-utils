function [patches locations bands] = extractAllPatches(c1r,patchSize)
% features = extractAllPatches(c1r,patchSize)
% Author: Josh Rule
%
% key assumption: a single c1 activation and a single patch size

patches = [];
for iBand = 1:length(c1r)
    b = c1r{iBand};
    [nRows nCols ~] = size(b);
    for iRow = 1:(nRows-patchSize(1)+1)
        for iCol = 1:(nCols-patchSize(2)+1)
            r1 = iRow;
            c1 = iCol;
            r2 = r1+patchSize(1)-1;
            c2 = c1+patchSize(2)-1;
            if r1>0 && c1>0 && r2 <= nRows && c2 <= nCols &&...
                sum(sum(sum(isnan(b(r1:r2,c1:c2,:))))) == 0
                idx = size(patches,1)+1;
                patches(idx,:) = reshape(b(r1:r2,c1:c2,:),1,[]);
                locations(idx,:) = [iRow iCol];
                bands(idx) = iBand;
            end
        end
    end
end
