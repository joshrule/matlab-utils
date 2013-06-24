function plotFICorrelation(fi1,fi2,patchSpecs)
    clf;

    hold all;
    [x,y] = rankFI(fi1,fi2,patchSpecs);
    plot(x(1,:),y(1,:),'r+');
    plot(x(2,:),y(2,:),'g+');
    plot(x(3,:),y(3,:),'b+');
    clear x y

    xlabel('Human vs. Negative FI');
    ylabel('AK vs. Negative FI');
    title('Correlation of FI for 2012 Universal Feature Set (1000/size) across Classification Problems (AK vs. Negative & Human vs. Negative)');
    legend('size 4','size 8','size 12','Location','Best');
%   axis([0 0.6 0 0.6]);
end

function [x,y] = rankFI(fi1,fi2,patchSpecs)
    nPatchSizes = size(patchSpecs,2);
    patchesPerSize = patchSpecs(4,1); % hack!
    for iSize = 1:nPatchSizes
        x(iSize,:) = fi1((patchesPerSize*(iSize-1))+1:patchesPerSize*iSize);
        y(iSize,:) = fi2((patchesPerSize*(iSize-1))+1:patchesPerSize*iSize);
    end
end
