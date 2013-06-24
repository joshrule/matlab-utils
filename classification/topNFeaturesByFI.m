function mFI = topNFeaturesByFI(m,labels,n)
% m is a 2-d examples x features matrix
% create a feature matrix of only the most informative features from each class.
    mFI = [];
    for iClass = 1:size(labels,1)
        pos = find( labels(iClass,:));
        neg = find(~labels(iClass,:));
        [fi, rankedFeatures] = sort(fisher(m(pos,:),m(neg,:)),'descend');
        mFI = [mFI; m(rankedFeatures(1:n),:)];
    end
end
