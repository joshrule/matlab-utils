function categoricalFeatureCorrelations(labels,imgNames,c2,c3,c3Wnids, ...
  targetWnids,N,outDir,simFile,blockSize,maxSize)
% categoricalFeatureCorrelations(labels,imgNames,c2,c3,c3Wnids, ...
%   targetWnids,N,outDir,simFile)
%
% compute the strength of feature correlations with a given target category
%
% labels: [nClasses nImgs] matrix, the labels according to outputWnid
% imgNames: nImgs cell vector of strings, the image filenames
% c2: [nC2Features nImgs] array, the C2 responses
% c3: [nC3Features nImgs] array, the C3 responses
% c3Wnids: nC3Features cell vector of strings, WordNet IDs for C3 categories
% targetWnids: nClasses cell vector of strings, WordNet IDs for output categories
% N: scalar, the number of categories to compare for C3 features
% outDir: string, in which directory on disk to write the results
% simFile: string, where on disk to find the perl file allowing semantic
%   distance calculations.
% blockSize: 2 vector, the rows and columns of the pixel blocks
% maxSize: scalar, maximum edge length when resizing images
    [~,~,pixelScores] = pixelBasedMetrics(imgNames,blockSize,maxSize);
    save([outDir 'pixelScores.mat'],'pixelScores','blockSize','maxSize');
    for iClass = 1:length(targetWnids)
        iLabels = labels(iClass,:);
        meanDistances(pixelScores,iLabels,N,[outDir 'pixelCorrs.mat']);
        meanDistances(c2Scores,iLabels,N,[outDir 'c2Corrs.mat']);
        meanDistances(c3,iLabels,N,[outDir 'c3Corrs.mat'], ...
          c3Wnids,targetWnids{iClass},simFile);
    end
end

function meanDistances(features,labels,N,outFile,wnids,target,simFile)
% a helper function for the above
    [corrs,idx] = sort(corr(features',labels'),'descend'); 
    bestChoices = idx(1:N);
    randChoices = randperm(length(idx),N);
    bestCorrs = corrs(bestChoices);
    randCorrs = corrs(randChoices);
    save(outFile,'corrs','bestChoices','randChoices','bestCorrs','randCorrs');
    if (nargin > 4)
        bestWnids = wnids(bestChoices);
        randWnids = wnids(randChoices);
        for i = 1:N
           bestDist(i) = str2num(perl(simFile,target,bestWnids{i}));
           randDist(i) = str2num(perl(simFile,target,randWnids{i}));
        end
        save(outFile,'bestDist','randDist','-append');
    end
end
