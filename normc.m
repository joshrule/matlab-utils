function mNormed = normc(m)
mNormed = m./repmat(sqrt(sum(m.^2,1)),size(m,1),1);
mNormed(~isfinite(mNormed)) = 1;
