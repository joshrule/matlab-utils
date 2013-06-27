function mNormed = normr(m)
% mNormed = normr(m)
%
% normalize each row of a matrix to length 1.
%
% m: double array, the raw matrix
%
% mNormed: double array, the normed matrix
    mNormed = m./repmat(sqrt(sum(m.^2,2)),1,size(m,2));
    mNormed(~isfinite(mNormed)) = 1;
end
