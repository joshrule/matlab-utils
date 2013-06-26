function features = chooseFeatures(x,y,featureClasses,k)
% features = chooseFeatures(x,y,featureClasses,k)
%
% given a set of examples, choose a subset of features for classification
%
% x: [nFeatures nExamples] array holding feature values.
% y: [nClasses nExamples] array,  the class labels of examples in x.
% featureClasses: vector of length nFeatures, the class from which each 
%     feature was drawn.
% k: scalar, if 0 < k < 1, k*nFeatures features will be selected. 
%     If k >= 1, min(k,nFeatures) will be selected.
%
% features: vector, the indices of the chosen features
    if (nargin < 4) k = size(x,1); end;

    if (nargin < 3) featureClasses = []; end;

    nFeatureClasses = length(unique(featureClasses));
    if nFeatureClasses == 0 % random
        indices = randperm(size(x,1));
    else % FI
        for iClass = 1:nFeatureClasses
            targs =  find(y(iClass,:));
            dtors = find(~y(iClass,:));
            classFeatures = find(featureClasses == iClass);
            fi(classFeatures) = fisher(x(classFeatures,targs)',...
                                       x(classFeatures,dtors)');
        end
        [~,indices] = sort(fi,'descend');
    end
    if k > 0 && k < 1
        features = indices(1:floor(k*size(x,1)));
    elseif k >= 1
        features = indices(1:min(k,size(x,1)));
    else % k < 0
        features = [];
    end
end
