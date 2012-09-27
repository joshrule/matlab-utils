function [pOut, labels] = universalPatches(pIn,k)
% [pOut, labels] = universalPatches(pIn,k)
%
% use centroids from kmeans clustering as "universal" patches
%
% pIn: cell array, the patches over which to run kmeans
% k: scalar, the number of patches per size, the number of clusters to make
%
% pOut: cell array, the patches after kmeans
% labels: cell array, the centroids to which each patch from pIn was assigned

    [labels,pOut] = cellfun(@(x) kmeans(x,k),pIn,'UniformOutput',0);
end
