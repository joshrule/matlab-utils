function mSigmoid = sigmoid(m)
% mSigmoid = sigmoid(m)
%
% scale a matrix to sit on a sigmoid rather than a line
%
% m: double array, the raw matrix
%
% mSigmoid: the sigmoid matrix
    a = min(m,[],1);
    b = max(m,[],1);
    m0To1 = bsxfun(@times,bsxfun(@minus,m,a),((b-a).^-1));
    mSigmoid = 1./(1+exp(6-12.*m0To1));
end
