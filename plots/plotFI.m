function [fi,idx] = plotFI(m)
    clf; f = figure();


%   [x,y] = hist(m,100);
%   z = bar(y,x);
%   set(z(1),'FaceColor','r','EdgeColor','r');
%   set(z(2),'FaceColor','b','EdgeColor','b');
    hist(m,100)
    xlabel('Mean FI');
    ylabel('Number of Patches');
    Title('Mean FI across Category, Master Patches, size 2x2, ImageNet');
%   legend('distractors','faces','Location','Best');
%   legend boxoff
%   axis([0 3.0 0 100]);
    plot2svg('~/Dropbox/josh/inbox/master-activations-avg-fi.svg',f);

    fi = 0; idx = 0;

%   line = ('+' '.' 'o' 'x' '*' 'd' 's'];
%   hold all;
%   for iClass = 1:size(labels,1)
%       pos = find( labels(iClass,:));
%       neg = find(~labels(iClass,:));
%       [fi(iClass,:), idx(iClass,:)] = sort(fisher(m(pos,:),m(neg,:)),'descend');
%       [x,y] = rankFI(fi,idx,patchSpecs);
%       plot(x(1,:),y(1,:),['r' line(mod(iClass,7)+1)]);
%       plot(x(2,:),y(2,:),['g' line(mod(iClass,7)+1)]);
%       plot(x(3,:),y(3,:),['b' line(mod(iClass,7)+1)]);
%   end
%   hold off;

%   xlabel('Patch Number');
%   ylabel('FI');
%   title('Effect of Patch Size on FI');
%   text(20,0.5,{'red (size 4)','green (size 8)','blue (size 12)'});
%   axis([0 500 0 0.6]);
end

function [x,y] = rankFI(sorted,idx,patchSpecs)
    nPatchSizes = size(patchSpecs,2);
    patchesPerSize = 1000; % hack!
    for iSize = 1:nPatchSizes
        x(iSize,:) = find(ismember(idx,(patchesPerSize*(iSize-1))+1:patchesPerSize*iSize));
        y(iSize,:) = sorted(x(iSize,:));

    end
end
