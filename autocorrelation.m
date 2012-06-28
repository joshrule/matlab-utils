function correlations = autocorrelations(m,type)
% m is a 2-d examples x features matrix
% returns feature x feature or example x example autocorrelations
    if strcmp(type,'feature')
        mCN = normc(bsxfun(@minus,m,mean(m,2)));
        correlations = mCN'*mCN;
    else % example
        mCN = normr(bsxfun(@minus,m,mean(m,1)));
        correlations = mCN*mCN';
    end
end
