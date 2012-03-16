function model = kmeansTrain(examples,labels)
% model = kmeansTrain(examples,labels)
%
% trains a kmeans classifier
%
% args:
%
%     examples: an p x n matrix, where p = nExamples and n = nFeatures
%
%     labels: a vector of length p, the labels for each example. Labels should
%     be in the range 1:k, where k = nClasses
%
% returns: model, an k x n matrix, where k = nClasses and n = nDimensions. Each
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
