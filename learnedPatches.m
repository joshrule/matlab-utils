function [ROCareas, diversities, patchUpdateCounts, initialPatches, learningPatches] = learnPatches(nTrainingRounds,imgNames,imgLabels,c1bands,gaborSpecs,patchSpecs,decayType,patchType)
% [ROCareas, diversities, patchUpdateCounts, learningPatches] = learnPatches(nTrainingRounds,imgLists,c1bands,gaborSpecs,patchSpecs,decayType,patchType)
%
% Given a set of images, learn patches based on area of maximum activation.
% That is, after initializing a set of patches, morph each patch to look
% slightly more like the area in a testing image which maximally activated the
% patch.
%
% args:
%
%     nTrainingRounds: # of times new patches are learned per experiment
%
%     imgNames: names of images available for patch extraction and testing
%
%     imgLabels: class labels for the images
%
%     c1bands: information about what c1 bands to use
%
%     gaborSpecs: information about the gabor filters to use
%
%     patchSpecs: information about what size and number of patches to generate
%
%     decayType: 'exponential' or 'linear', how learning decays
%
%     patchType: 'random' or 'extracted', how patches are initialized
%
% returns: 
%
%     ROCareas: an nTrainingRounds x nPercentBests matrix of ROC areas showing
%     the algorithm's effectiveness
%
%     diversities: an nTrainingRounds x nPercentBests matrix measuring the
%     similarity of patches generated
%
%     patchUpdateCounts: an nTrainingRounds x nPercentBests x nPatches x
%     nPatches matrix showing how frequently each patch is updated
%
%     learningpatches: the final sets of generated patches, one for each
%     percentage level of patches updated

patchSizes = patchSpecs.patchSizes;
nPatchSizes = size(patchSizes,2);
nPatchesPerSize = patchSpecs.patchesPerSize;
nPatches = nPatchSizes * nPatchesPerSize;
nOrientations = 4; % hack
percentBests = 1:9:100; % hack
nPercentBests = length(percentBests);

cvp1 = cvpartition(imgLabels','holdout',0.20);
patchImgNames = imgNames(cvp1.test(1));
experimentalImgNames = imgNames(cvp1.training(1));
labels = imgLabels(cvp1.training(1));
imgs = readImages(experimentalImgNames);

ROCareas    = zeros(nTrainingRounds,nPercentBests,'single');
diversities = zeros(nTrainingRounds,nPercentBests,'single');
patchUpdateCounts = zeros(nTrainingRounds,nPercentBests,nPatches,nPatches,'uint8');

% generate C1 responses for all images
[filterSizes,filters,c1OL,~] = initGabor(gaborSpecs.orientations, ...
                                         gaborSpecs.receptiveFieldSizes, ...
                                         gaborSpecs.div);
C1cache = c1rFromCells(imgs,filters,filterSizes,c1OL,c1bands.c1Space,c1bands.c1Scale);

% split images into testing and training sets
cvp2 = cvpartition(labels','holdout',0.20);
training = cvp2.training(1);
test = cvp2.test(1);

testImgs = imgs(1,test);
testLabels = labels(test);
testC1cache = C1cache(test);

trainingImgs = imgs(1,training);
trainingLabels = labels(training);
trainingC1cache = C1cache(training);
nTrainingImgs = length(find(training));

% Create patches from patch image set
    [initialPatches,~,~] = genPatches(patchImgNames,patchSpecs,patchType);

% Initialize all learningPatches{percentBest} to the initial patch set
learningPatches = cell(1,nPercentBests);
for i=1:nPercentBests
   learningPatches{1,i} = initialPatches;
end

for iTrainingRound=1:nTrainingRounds  % MAIN LEARNING LOOP
    % Pick a random image from the training set
    randomIndex = ceil(rand()*nTrainingImgs);
    fprintf('training iteration %d using training image %d\n', iTrainingRound, randomIndex);
    randomImg = trainingImgs(1,randomIndex);
    randomC1cache = trainingC1cache(randomIndex);

    if strcmp(decayType,'linear')
        alpha = (-1/nTrainingRounds)*iTrainingRound + 1;
    else % exponential decay
        alpha = exp(-(iTrainingRound-1)/(nTrainingRounds/6));
    end

    percentCount = 1;
    for percentBest=percentBests % PERCENT BEST TRAINING LOOP
        % Run HMAX on the random training image for all patches.
        [C2R,~,bestBands,bestLocations,~,~] = extractC2FromCell(filters,filterSizes,c1bands.c1Space,c1bands.c1Scale,c1OL,learningPatches{1,percentCount},randomImg,size(patchSizes,2),patchSizes,0,randomC1cache,0,1);

        % Find percentBest best-matched patches from patches{percentBest}
        nBestPatches = ceil(nPatches * percentBest / 100);
        [sortedC2R sortedC2indices] = sort(C2R);
        bestPatchIndices = sortedC2indices(1:nBestPatches);

        for iPatch=1:nBestPatches % PATCH TRAINING LOOP
            % Find the winning patch
            bestPatchIndex = bestPatchIndices(iPatch);
            bestPatchSizeIndex = ceil(bestPatchIndex / nPatchesPerSize);
            baseLocation = nPatchesPerSize*(bestPatchSizeIndex -1 );
            offsetLocation = (bestPatchIndex - baseLocation);
            winningPatch = learningPatches{1,percentCount}{bestPatchSizeIndex}(:,offsetLocation);
            winningPatchSize = squeeze(patchSizes(:,bestPatchSizeIndex));
            winningPatchMatrix = reshape(winningPatch,winningPatchSize');

            % Find the center of the patch in the best-matching band.
            winningBandLocation = squeeze(bestLocations(bestPatchIndex,:));
            % Find the best matching band
            winningBandIndex = bestBands(bestPatchIndex);

            % find the corners of the patch within the winning band
            rowmin = winningBandLocation(1) - ceil(winningPatchSize(1)/2)+1;
            rowmax = winningBandLocation(1) + floor(winningPatchSize(1)/2);
            colmin = winningBandLocation(2) - ceil(winningPatchSize(2)/2)+1;
            colmax = winningBandLocation(2) + floor(winningPatchSize(2)/2);

            try % when the patch best matches something on the border of the image
                if iTrainingRound ~= 1
                   winningBandMatrix = randomC1cache{1}{winningBandIndex}(rowmin:rowmax,colmin:colmax,:);
                else
                   winningBandMatrix = winningPatchMatrix;
                end
            catch MException
                fprintf('ERROR: %d %d %d %d, but %d %d %d\n',rowmin,rowmax,colmin,colmax,size(randomC1cache{1}{winningBandIndex}));
                winningBandMatrix = winningPatchMatrix;
                continue;
            end

            newPatch = zeros(winningPatchSize(1),winningPatchSize(2),4);
            for iOrientation=1:nOrientations
                newPatch(:,:,iOrientation) = (winningPatchMatrix(:,:,iOrientation) +...
                                             (0.2*alpha)*(winningBandMatrix(:,:,iOrientation)-...
                                                          winningPatchMatrix(:,:,iOrientation)));
                newPatch(newPatch(:,:,iOrientation) < 0) = 0;
            end
            learningPatches{1,percentCount}{bestPatchSizeIndex}(:,offsetLocation) = newPatch(:);

        end % PATCH TRAINING LOOP

        % get the new C2 results for the trainingImgs and the testImgs
        [C2Rtraining,~,~,~,~,~] = extractC2FromCell(filters,filterSizes,c1bands.c1Space,c1bands.c1Scale,c1OL,learningPatches{1,percentCount},trainingImgs,size(patchSizes,2),patchSizes,0,trainingC1cache,0,1);
        [C2Rtest,~,~,~,~,~] = extractC2FromCell(filters,filterSizes,c1bands.c1Space,c1bands.c1Scale,c1OL,learningPatches{1,percentCount},testImgs,size(patchSizes,2),patchSizes,0,testC1cache,0,1);

        if percentCount > 1
            debugA= sum(sum(C2Rtraining == C2RtrainingPrev))/numel(C2Rtraining);
            debugB= sum(sum(C2Rtest == C2RtestPrev))/numel(C2Rtest);
        end

        C2RtrainingPrev = C2Rtraining;
        C2RtestPrev = C2Rtest;

        % classify using the C2 results for trainingImgs as training and the C2 results for testImgs as testing
        model = svmtrain(trainingLabels', C2Rtraining', '-q -t 0');
        [predictions,accuracy,probs] = svmpredict(testLabels', C2Rtest', model);

        % get this round's stats
        patchUpdateCounts(iTrainingRound,percentCount,:,:) = visualRank(sortedC2indices);
        ROCareas(iTrainingRound,percentCount) = auc(predictions,testLabels);
        diversities(iTrainingRound,percentCount) = diversity(learningPatches{1,percentCount}{1});

        percentCount = percentCount + 1;
    end % PERCENT BEST TRAINING LOOP
end % MAIN LEARNING LOOP


function patchRanks = visualRank(sortedIndices)
nPatches = size(sortedIndices,1);
patchRanks = zeros(nPatches,nPatches); % row = patch index, col = ranking
% for the patch ranked i, insert 1 for ranks >= i 
% (if rank == 5, then it is also in the top 6,7,8...)
for iPatch=1:nPatches
    patchRanks(sortedIndices(iPatch),:) = [zeros(1,iPatch-1) ones(1,nPatches-iPatch+1)];
end
