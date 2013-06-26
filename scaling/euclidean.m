function mEuclidean = euclidean(mGaussian,sigma)
% mEuclidean = euclidean(mGaussian,sigma)
%
% rescale a Gaussian-space array to Euclidean space
%
% mGaussian: double array, an array in Gaussian space
% sigma: double scalar, the standard deviation of the gaussian
%
% mEuclidean: double array, mGaussian now scaled to Euclidean space
    mEuclidean = sqrt((-2*sigma.^2).*log(mGaussian));
end
