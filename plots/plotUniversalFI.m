function plotUniversalFI(fi,patchSpecs)
    clf;

    hold all;
    [x,y] = rankFI(fi.sorted{1},fi.idx{1},patchSpecs{1});
    plot(x(1,:),y(1,:),'r+');
    plot(x(2,:),y(2,:),'g+');
    plot(x(3,:),y(3,:),'b+');
    clear x y

    [x,y] = rankFI(fi.sorted{2},fi.idx{2},patchSpecs{2});
    plot(x(1,:),y(1,:),'ro');
    plot(x(2,:),y(2,:),'go');
    plot(x(3,:),y(3,:),'bo');
    clear x y

    [x,y] = rankFI(fi.sorted{3},fi.idx{3},patchSpecs{3});
    plot(x(1,:),y(1,:),'r.');
    plot(x(2,:),y(2,:),'g.');
    plot(x(3,:),y(3,:),'b.');
    clear x y

    [x,y] = rankFI(fi.sorted{4},fi.idx{4},patchSpecs{4});
    plot(x(1,:),y(1,:),'rd');
    plot(x(2,:),y(2,:),'gd');
    plot(x(3,:),y(3,:),'bd');
    clear x y

    [x,y] = rankFI(fi.sorted{5},fi.idx{5},patchSpecs{5});
    plot(x(1,:),y(1,:),'rx');
    plot(x(2,:),y(2,:),'gx');
    plot(x(3,:),y(3,:),'bx');
    clear x y

    [x,y] = rankFI(fi.sorted{6},fi.idx{6},patchSpecs{6});
    plot(x(1,:),y(1,:),'r*');
    plot(x(2,:),y(2,:),'g*');
    plot(x(3,:),y(3,:),'b*');
    clear x y


    xlabel('Patch Number');
    ylabel('FI');
    title('Effect of Patch Size on FI with Universal Feature Sets (AK vs. Negative)');
    text(20,0.5,{'red (size 4)','green (size 8)','blue (size 12)','+ (universal 2007)','o (2012 100/size)','. (2012 200/size)','d (2012 400/size)','x (2012 800/size)','* (2012 1000/size)'});
    axis([0 500 0 0.6]);
end

function [x,y] = rankFI(sorted,idx,patchSpecs)
    nPatchSizes = size(patchSpecs,2);
    patchesPerSize = patchSpecs(4,1); % hack!
    for iSize = 1:nPatchSizes
        x(iSize,:) = find(ismember(idx,(patchesPerSize*(iSize-1))+1:patchesPerSize*iSize));
        y(iSize,:) = sorted(x(iSize,:));

    end
end
