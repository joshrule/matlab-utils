function mGaussian = gaussian(mEuclidean,sigma)
% mGaussian = gaussian(mEuclidean,sigma)
%
% make the Euclidean distance activation of a matrix Gaussian

    mGaussian = exp(-(mEuclidean.^2)./(2*sigma.^2));
end
