function equalRep = equalRep(labels,ceiling)
% equalRep = equalRep(labels,ceiling)
%
% given a set of binary labels, choose the maximum number of
% both positive and negative labels such that there's an equal number of both
%
% labels: nExamples vector, the class labeling of all examples
% ceiling: scalar, the maxmimum number of positives or negatives to choose
%
% equalRep: nExamples vector, 1 if chosen as a representative, 0 otherwise
    if (nargin < 2) ceiling = inf; end;
    pos = find(labels);
    neg = find(~labels);
    nExamples = min([length(pos) length(neg) ceiling]);
    equalRep = false(1,length(labels));
    equalRep([pos(randperm(length(pos),nExamples)) ...
      neg(randperm(length(neg),nExamples))]) = true;
end
