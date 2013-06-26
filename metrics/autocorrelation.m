function correlations = autocorrelations(m,type)
% correlations = autocorrelations(m,type)
%
% returns row x row or column x column autocorrelations
%
% m: double array, the matrix to auto correlate
%
% correlations: double array, the correlation between each row/column and
%   every other row/column, such that correlations(i,j) is the correlation
%   between the ith and jth row/column, respectively.
    if strcmp(type,'column')
        mCN = normc(bsxfun(@minus,m,mean(m,2)));
        correlations = mCN'*mCN;
    else % row
        mCN = normr(bsxfun(@minus,m,mean(m,1)));
        correlations = mCN*mCN';
    end
end
