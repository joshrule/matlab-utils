function detector = hardNegativeMining(positives, negatives, detector, ...
  startPerIter, alpha, threshold, svmTrainFlags, svmTestFlags)
% detector = hardNegativeMining(positives, negatives, detector, ...
%   startPerIter, alpha, threshold, svmTrainFlags, svmTestFlags)
%
% Core Logic: saurabh.me@gmail.com (Saurabh Singh).
% Revised: rsj28@georgetown.edu (Josh Rule).
%
% Perform hard negative mining in training an SVM classifier
%
% positives: [nPositives nFeatures] array, the positive examples
% negatives: [nNegatives nFeatures] array, the initial negative examples
% detector: struct, the initial SVM classifier
% startPerIter: scalar, the number of negatives to start with
% alpha: scalar, a parameter of the growth rate in negatives such that
%   nNegs = floor(startPerIter * 2^(iter-1)*alpha)
% threshold: scalar, the probability at which a negative becomes hard, ranges
%   from 0 to 1.
% svmTrainFlags: string, flags for training an SVM using LIBSVM
% svmTestFlags; string, flags for testing an SVM using LIBSVM
%
% detector, struct, the final SVM detector
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
% positiveProbs = scoreNegatives(data, detector, svmFlags)
%
% pass a set of data through a classifier
%
% data: [nExamples nFeatures] array, the examples
% detector: struct, the SVM classifier
% svmFlags: string, options for LIBSVM
%
% positiveProbs: nExamples vector, the probability each example is positive
  randInds = randperm(size(data,2));
  labels = zeros(size(data,2),1);
  [~,~,allProbs] = svmpredict(labels,data(:,randInds)',detector, svmFlags);
  positiveProbs(randInds) = allProbs(:,2-detector.Label(1));
end

function detector = trainDetector(positives,negatives,svmFlags)
% detector = trainDetector(positives,negatives,svmFlags)
%
% train an SVM classifier
%
% positives: [nPositives nFeatures] array, the positive examples
% negatives: [nNegatives nFeatures] array, the initial negative examples
% svmFlags: string, options for LIBSVM
% 
% detector: struct, the trained detector
  labels = [ones(size(positives,2),1); zeros(size(negatives,2),1)];
  data = [positives negatives]';
  randInds = randperm(length(labels));
  detector = svmtrain(labels(randInds),data(randInds,:),svmFlags);
end
