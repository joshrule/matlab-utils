function diversity = diversity(patches)
% diversity = diversity(patches)
%
% calculate the diversity of a set of patches as the normed arc-cosine of the
%   autocorrelation of the patches.
%
% patches: double array, matrix representing S2 patches such that each column
%   is a new patch.
%
% diversity: double scalar, a measure of patch diversity
    diversity = norm(acos(autocorrelation(patches,'column'));
end
