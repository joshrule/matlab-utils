function features = chooseFeatures(x,y,featureClasses,k,type,scores)
% features = chooseFeatures(x,y,featureClasses,k)
%
% given a set of examples, choose a subset of features for classification
%
% x: [nExamples nFeatures] array holding feature values.
% y: [nExamples nClasses] array,  the class labels of examples in x.
% featureClasses: vector of length nFeatures, the class from which each 
%     feature was drawn.
% k: scalar, if 0 < k < 1, k*nFeatures features will be selected. 
%     If k >= 1, min(k,nFeatures) will be selected.
% type: string, the sort of selection process to use
% scores: [nExamples nFeatures] array, a weight to give each feature for each
% image, if there is additional information available, i.e. a per-category
% similarity score as in our C3 simulations
%
% features: vector, the indices of the chosen features
    if (nargin < 6) scores = x; end;
    if (nargin < 5) type = 'max'; end;
    if (nargin < 4) k = size(x,2); end;
    if (nargin < 3) featureClasses = []; end;

    nFeatureClasses = length(unique(featureClasses));
    if nFeatureClasses == 0 && strcmp(type,'random')
        indices = randperm(size(scores,2));
    elseif nFeatureClasses == 0 && strcmp(type,'max') && size(y,2) == 1
        [~,indices] = sort(mean(scores(find(y),:)),'descend');
    elseif nFeatureClasses == 0 && strcmp(type,'min') && size(y,2) == 1
        [~,indices] = sort(mean(scores(find(y),:)),'ascend');
    elseif nFeatureClasses == 0 && ~isempty(str2num(type)) && size(y,2) == 1
        indices = find(mean(scores(find(y),:)) > str2num(type));
    else % FI
        for iClass = 1:nFeatureClasses
            targs =  find(y(iClass,:));
            dtors = find(~y(iClass,:));
            classFeatures = find(featureClasses == iClass);
            fi(classFeatures) = fisher(scores(classFeatures,targs)',...
                                       scores(classFeatures,dtors)');
        end
        [~,indices] = sort(fi,'descend');
    end
    if k > 0 && k < 1 && ~isempty(indices)
        features = indices(1:floor(k*size(x,2)));
    elseif k >= 1 && ~isempty(indices)
        features = indices(1:min(length(indices),min(k,size(x,2))));
    else % k < 0
        features = [];
    end
end
