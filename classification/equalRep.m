function equalRep = equalRep(labels,ceiling,ratio)
% equalRep = equalRep(labels,ceiling)
%
% given a set of binary labels, choose the maximum number of
% both positive and negative labels such that there's an equal number of both
%
% labels: nExamples vector, the class labeling of all examples
% ceiling: scalar, the maxmimum number of positives or negatives to choose
% ratio: scalar, the number of negatives for each positive
%
% equalRep: nExamples vector, 1 if chosen as a representative, 0 otherwise
    if (nargin < 3) ratio   = 1; end;
    if (nargin < 2) ceiling = inf; end;
    pos = find(labels);
    neg = find(~labels);
    nExamples = min([length(pos) floor(length(neg)/ratio) ceiling]);
    equalRep = false(1,length(labels));
    equalRep([pos(randperm(length(pos),nExamples)) ...
      neg(randperm(length(neg),nExamples*ratio))]) = true;
end
