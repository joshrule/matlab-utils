function model = kmeansTrain(examples,labels)
% model = kmeansTrain(examples,labels)
%
% train a kmeans classifier
%
% examples: [p n] matrix, where p = nExamples and n = nFeatures
% labels: p vector, the labels for each example. Labels should
%   be in the range 1:k, where k = nClasses
%
% model, [k n] array, where k = nClasses and n = nDimensions. Each
% row, i, is the centroid best fitting all examples from class i, as determined
% by kmeans().
    nClasses = length(unique(labels));
    for iClass = 1:nClasses
        [~,model(iClass,:)] = kmeans(examples(find(labels == iClass),:),1,...
                              'replicates',10,...
                              'start','sample',...
                              'emptyaction','singleton');
    end
end
