function initializeMFValue(mf,var,value)
    mfVars = whos('-file',mf.Properties.Source);
    if ~ismember({var},{mfVars.name})
        mf.(var) = value;
    end
end
