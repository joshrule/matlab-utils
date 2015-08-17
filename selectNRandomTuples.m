function tuples = selectNRandomTuples(N,tupleSpace)
% tuples = selectNRandomTuples(N,tupleSpace)
%
% generate N randomly selected tuples from a pre-defined space
%
% N: scalar, the number of tuples to generate
% tupleSpace: cell vector of cell vectors, where each tupleSpace{i} represents
%   the possible choices for the i^{th} element of the tuple

    tuples = struct();
    for iElement = 1:length(tupleSpace)
        idx(:,iElement) = randi([1 length(tupleSpace{iElement})],N,1);
        items(:,iElement) = {tupleSpace{iElement}{idx(:,iElement)}};
    end
    for iN = 1:N
        tuples(iN).idx = idx(iN,:);
        tuples(iN).item = items(iN,:);
    end
end
