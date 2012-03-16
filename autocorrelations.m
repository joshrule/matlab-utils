function [featureCorrelations, exampleCorrelations] = autocorrelations(examples)
    featureCorrelations = normr(examples) * normr(examples)';
    exampleCorrelations = normc(examples)' * normc(examples);
end
