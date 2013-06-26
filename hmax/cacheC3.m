function imgFiles = cacheC3(outFile,c2File,modelFile,paramFile,models)
% imgFiles = cacheC3(outFile,c2File,modelFile,paramFile,models)
%
% given c2Caches and a set of C3 models, write the C3 activations to disk
%
% outFile: string, the location in which to write the C3 activations to disk
% c2File: string, the location of the C2 responses on disk
% modelFile: string, the location of the C3 units on disk
% paramFile: string, the location of the parameters which generated the C3 units
% models: cell array of classifiers, the models themselves, to prevent massive
%   cache thrashing from loading and reloading the models
%
% imgFiles: cell array of strings, the images processed
    if (nargin < 5) load(modelFile,'models'); end;
    load(paramFile,'params');
    load(c2File,'imgFiles','c2');
    c3 = testC3(c2,models,params.method)
    save(outFile,'c3','imgFiles','modelFile','paramFile');
end
