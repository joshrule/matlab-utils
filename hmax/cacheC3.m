function c3 = cacheC3(c2Files,modelFile,paramFile,models)
% cacheC3(c2Files,modelFile,paramFile,models)
%
% given c2Caches and a set of C3 models, write the C3 activations to disk
%
% c2Files: string, the locations of the C2 responses on disk
% modelFile: string, the location of the C3 units on disk
% paramFile: string, the location of the parameters which generated the C3 units
% models: cell array of classifiers, the models themselves, to prevent massive
%   cache thrashing from loading and reloading the models
    if (nargin < 4)
        fprintf('loading models');
        load(modelFile,'models');
    end;
    for i = 1:length(c2Files)
        activations = load(c2Files{i},'c2','-mat');
        c2(:,i) = activations.c2;
    end
    c3 = testC3(c2,models);
end
