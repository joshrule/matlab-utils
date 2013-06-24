function equalRep = equalRep(labels,ceiling)
% equalRep = equalRep(labels,ceiling)
%
% given a set of binary labels, choose the maximum number of
% both positive and negative labels such that there's an equal number of both
    if (nargin < 2) ceiling = inf; end;
    pos = find(labels);
    neg = find(~labels);
    nExamples = min([length(pos) length(neg) ceiling]);
    equalRep = false(1,length(labels));
    equalRep([pos(randperm(length(pos),nExamples)) neg(randperm(length(neg),nExamples))]) = true;
end
