function tuples = selectNUniqueTuples(N,tupleSpace)
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
