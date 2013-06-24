function detector = hardNegativeMining(positives, negatives, detector, ...
  startPerIter, alpha, threshold, svmTrainFlags, svmTestFlags)
% Author: saurabh.me@gmail.com (Saurabh Singh).
% Revised: rsj28@georgetown.edu (Josh Rule).

  if detector.Label(1)
      oldNegs = detector.SVs(detector.nSV(1)+1:end,:)';
  else
      oldNegs = detector.SVs(1:detector.nSV(1),:)';
  end
  oldScores = scoreNegatives(oldNegs, detector, svmTestFlags);

  maxElements = size(negatives,2);
  currentInd = 1; % the first negative to use
  iter = 1; % the iteration number of the while loop
  while currentInd <= maxElements % Mine currentInd:finInd negative images
    imgsPerIter = floor(startPerIter * 2^((iter - 1)*alpha));
    finInd = min(currentInd + imgsPerIter - 1, maxElements);
    fprintf('> Mining Hard Negatives using %d images <\n',finInd-currentInd+1);
  
    % choose the hard negatives
    possibleNegs = negatives(:,currentInd:finInd);
    possibleScores = scoreNegatives(possibleNegs, detector, svmTestFlags);
    allScores = [oldScores possibleScores];
    allNegs = [oldNegs possibleNegs];
    newNegs = allNegs(:,(allScores > threshold));
    newScores = allScores(allScores > threshold);

    % train new detector
    detector = trainDetector(positives,newNegs,svmTrainFlags);
  
    currentInd = finInd + 1;
    iter = iter + 1;
    oldNegs = newNegs;
    oldScores = newScores;
  end
end

function positiveProbs = scoreNegatives(data, detector, svmFlags)
  randInds = randperm(size(data,2));
  labels = zeros(size(data,2),1);
  [~,~,allProbs] = svmpredict(labels,data(:,randInds)',detector, svmFlags);
  positiveProbs(randInds) = allProbs(:,2-detector.Label(1));
end

function detector = trainDetector(positives,negatives,svmFlags)
  labels = [ones(size(positives,2),1); zeros(size(negatives,2),1)];
  data = [positives negatives]';
  randInds = randperm(length(labels));
  detector = svmtrain(labels(randInds),data(randInds,:),svmFlags);
end
