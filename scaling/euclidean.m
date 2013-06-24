function mEuclidean = euclidean(mGaussian,sigma)
% mEuclidean = euclidean(mGaussian,sigma)
%
% make the Gaussian distance activation of a matrix Euclidean

    mEuclidean = sqrt((-2*sigma.^2).*log(mGaussian));
end
