function s = initializeStructValue(s,var,valHandle)
    if ~isfield(s,var)
        s.(var) = valHandle();
    end
end
