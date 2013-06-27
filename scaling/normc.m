function mNormed = normc(m)
% mNormed = normc(m)
%
% normalize each column of a matrix to length 1.
%
% m: double array, the raw matrix
%
% mNormed: double array, the normed matrix
    mNormed = m./repmat(sqrt(sum(m.^2,1)),size(m,1),1);
    mNormed(~isfinite(mNormed)) = 1;
end
