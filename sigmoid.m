function mSigmoid = sigmoid(m)
% m is a 2-d examples x features matrix
% sigmoid scales features to sit on a sigmoid rather than some other curve
    a = min(m,[],1);
    b = max(m,[],1);
    m0To1 = bsxfun(@times,bsxfun(@minus,m,a),((b-a).^-1));
    mSigmoid = 1./(1+exp(6-12.*m0To1));
end
