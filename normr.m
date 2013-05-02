function mNormed = normr(m)
mNormed = m./repmat(sqrt(sum(m.^2,2)),1,size(m,2));
mNormed(~isfinite(mNormed)) = 1;
