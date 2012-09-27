function [scaledData, lowerVals, upperVals] = scaleLIBSVMdata(data, lowerVals, upperVals, lower, upper)
% [scaledData, lowerVals, upperVals] = scaleLIBSVMdata(data, lower, upper, lowerVals, upperVals)
%
% scale LIBSVM data to sit within lower and upper
%
% args:
%
%     data: an nExamples x nFeatures array of examples
%
%     lower: the lower limit for scaled data
%
%     upper: the upper limit for scaled data
%
%     lowerVals: the lowest value for each feature (useful for scaling test data)
%
%     upperVals: the highest value for each feature (useful for scaling test data)
%
% returns: 
%
%     scaledData: an nExamples x nFeatures array of scaled examples with range
%     [lower, upper]
%
%     lowerVals, upperVals: as above

if (nargin < 5) upper =  1; end;
if (nargin < 4) lower =  0; end;
if (nargin < 3) upperVals = max(data); end;
if (nargin < 2) lowerVals = min(data); end;

% scale data
scaledData = NaN(size(data));
for iExample = 1:size(data,1)
    for iFeature = 1:size(data,2)
        if lowerVals(iFeature) == upperVals(iFeature)
            scaledData(iExample,iFeature) = (upper-lower)/2;
        elseif data(iExample,iFeature) == lowerVals(iFeature)
            scaledData(iExample,iFeature) = lower;
        elseif data(iExample,iFeature) == upperVals(iFeature)
            scaledData(iExample,iFeature) = upper;
        else % intermediate value
            scaledData(iExample,iFeature) = lower + (upper-lower) * ...
                                            (data(iExample,iFeature)-lowerVals(iFeature)) / ...
                                            (upperVals(iFeature)-lowerVals(iFeature));
        end
    end
end
