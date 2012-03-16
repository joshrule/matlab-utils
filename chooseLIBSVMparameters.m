function [gamma, c] = chooseLIBSVMparameters(labels, data, gammaRange, cRange, nFolds)
% [gamma, c] = chooseLIBSVMparameters(labels, data, gammaRange, cRange, nFolds)
%
% use nFold cross-validation over a grid of values to choose "best"
% hyperparameters C and gamma for an RBF kernel LIBSVM classifier
%
% args:
%
%     labels: a nExamples x 1 vector of class labels
%
%     data: a nExamples x nFeatures array of examples
%
%     gammaRange: a vector of ranges to be tested for Gamma
%
%     cRange: a vector of ranges to be tested for C
%
%     nFolds: the number of folds to use in cross-validation
%
% returns: the highest performing values for Gamma and C
%
% -q = no output
% -t 2 = RBF kernel
% -v nFolds = nFolds cross-validation
% -g iGamma = gamma value
% -c iCost = cost value

if (nargin < 5) nFolds = 5; end;
if (nargin < 4) cRange = -10:2:10; end;
if (nargin < 3) gammaRange = -10:2:10; end;

% scale data to prevent domination by high values
if (max(max(data)) > 1.0) || (min(min(data)) < -1.0)
    data = scaleLIBSVMdata(data);
end

% grid-search for "best" parameters
gamma = NaN;
c = NaN;
bestCV = 0;
for iGamma = gammaRange
    for iCost = cRange
        options = ['-q -t 2 -v ' num2str(nFolds) ' -g ' num2str(2^iGamma) ' -c ' num2str(2^iCost)];
        iCV = svmtrain(labels, data, options);
        if iCV > bestCV
            bestCV = iCV;
            gamma = iGamma;
            c = iCost;
        end
    end
end
