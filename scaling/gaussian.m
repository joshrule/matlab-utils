function mGaussian = gaussian(mEuclidean,sigma)
% mGaussian = gaussian(mEuclidean,sigma)
%
% rescale a Euclidean-space array to Gaussian space
%
% mEuclidean: double array, an aray in Euclidean space
% sigma: double scalar, the standard deviation of the gaussian
%
% mGaussian: double array, mEuclidean now scaled to Gaussian space
    mGaussian = exp(-(mEuclidean.^2)./(2*sigma.^2));
end
