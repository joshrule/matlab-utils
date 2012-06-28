function diversity = diversity(patches)
    diversity = norm(acos(autocorrelation(patches,'feature'));
end
