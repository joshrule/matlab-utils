function mFI = topNFeaturesByFI(m,labels,n)
% mFI = topNFeaturesByFI(m,labels,n)
%
% create a feature matrix of only the most informative features from each class.
%
% m: [nFeatures nExamples] array, the unfiltered example matrix
% labels: [nClasses nExamples] array, the class labels
% n: scalar, the number of features to keep per class
%
% mFI: [n*nClasses nExamples] array, the filtered example matrix
    mFI = [];
    for iClass = 1:size(labels,1)
        pos = find( labels(iClass,:));
        neg = find(~labels(iClass,:));
        [fi, rankedFeatures] = sort(fisher(m(pos,:),m(neg,:)),'descend');
        mFI = [mFI; m(rankedFeatures(1:n),:)];
    end
end
