function c = chooseLIBSVMparameters(labels, data, cRange, nFolds)
% c = chooseLIBSVMparameters(labels, data, cRange, nFolds)
%
% use nFold cross-validation over a grid of values to choose "best"
% hyperparameter C  for a linear kernel LIBSVM classifier
%
% labels: nExamples vector, the class labels
% data: [nExamples nFeatures] array, the training examples
% cRange: vector, ranges to be tested for C such that each C = 2^(cRange(i))
% nFolds: scalar, the number of folds to use in cross-validation
%
% c: scalar, the highest performing values for C
%
% -q = no output
% -t 0 = linear kernel
% -s 0 = C-SVC classifier
% -v nFolds = nFolds cross-validation
% -c iCost = cost value
    if (nargin < 5) nFolds = 8; end;
    if (nargin < 4) cRange = -10:1:10; end;

    % scale data to prevent domination by high values
    if (max(max(data)) > 1.0) || (min(min(data)) < -1.0)
        data = scaleLIBSVMdata(data);
    end

    % line-search for "best" parameters
    bestC = NaN;
    bestCV = 0;
    for iCost = cRange
        options = ['-q -t 0 -s 0 -b 1 -v ' num2str(nFolds) ' -c ' ...
          num2str(2^iCost)];
        iCV = svmtrain(labels, data, options);
        if iCV > bestCV
            bestCV = iCV;
            bestC = iCost;
        end
    end
    c = 2^bestC;
end
