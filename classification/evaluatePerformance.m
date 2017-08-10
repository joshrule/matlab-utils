function results = evaluatePerformance(tr,te,options,nTrain,nRuns,nFeatures,type,scores,classes)
% results = evaluatePerformance(x,y,cv,options,nFeatures)
%
% avg. precision and ROC AUC using cross-validation over a set of examples and labels
%
% x: [nFeatures nExamples] array, the feature values
% y: [nClasses nExamples] array, the class labels of examples in x
% cv: cell array of vectors, train/ignore splits, s.t. 1 = train, 0 = ignore
% options: options for the classifier
% nFeatures: scalar, the number of Features to use for classification, must be
%   less than the total number of features in x
% type: string, how to select features
% scores: [nFeatures nExamples] array, scores for feature selection
% classes: array, the classes to test
%
% results: [nClasses, nTrainingExamples, nRuns] struct, the classification data

fprintf('setting up evaluatePerformance, %f\n', posixtime(datetime));

poolobj = gcp('nocreate');
maxBatchSize = poolobj.NumWorkers;

nTrainingExamples = numel(nTrain);
nClasses = numel(classes);
[xs,ys,zs] = meshgrid(1:nClasses, 1:nTrainingExamples, 1:nRuns);
is = [xs(:) ys(:) zs(:)];

trainX = tr.x;
testX = te.x;
scoresX = scores.x;

function dir = prep_classification_data(i)
    total = tic;

    % prep the individual classification problems
    iC = is(i, 1);
    iT = is(i, 2);
    iR = is(i, 3);
    tC = classes(iC);

    % update the options
    options2 = options;
    options2.dir = [options2.dir '/' num2str(iC) ...
                                 '/' num2str(iT) ...
                                 '/' num2str(iR)];

    dir = ensureDir([options2.dir '/']);
    datafile = [dir 'data.mat'];
    if ~exist(datafile,'file')
        % create random split
        s = tic;
        y = tr.y(:,tC);
        split = little_cv(y,nTrain(iT));
        y_tr = y(split);
        fprintf('splitting: %.3fs\n', toc(s));

        % balance the positive and negative examples
        s = tic;
        [choices,w_tr] = balance_pos_neg_examples(y_tr,options2.N);
        split_choice = find(split);
        split_choice = split_choice(choices);
        y_tr = y_tr(choices);
        fprintf('balancing: %.3fs\n', toc(s));

        % log-transform & standardize the data 
        s = tic;
        [xTr,means,stds] = standardize(log(1+trainX(split_choice,:)),w_tr);
        xTe = standardize(log(1+testX),[],means,stds);
        fprintf('standardizings: %.3fs\n', toc(s));

        % choose features
        s = tic;
        scoresTr = scoresX(split_choice,:);
        chosenFeatures = chooseFeatures(y_tr,[],nFeatures,type,scoresTr);
        X_tr = xTr(:,chosenFeatures);
        X_te = xTe(:,chosenFeatures);
        fprintf('feature selection: %.3fs\n', toc(s));

        y_te = te.y;
        class = tC;
        index = iC;
        nTraining = sum(y_tr);
        run = iR;

        % save the data for classification
        s = tic;
        save(datafile,'y_tr','y_te','X_tr','X_te','w_tr','chosenFeatures', ...
              'class','index','nTraining','run','choices','options');
            fprintf('saving: %.3fs\n\n', toc(s));

        end
        if i < 100 || mod(i,100) == 0
            fprintf('elapsed time: %.3fs\n',toc(total));
        end
    end

    fprintf('number of runs: %d\n',size(is,1));
    for i = 1:size(is,1)
        dirs{i} = prep_classification_data(i);
    end
    fprintf('prepped!\n');

    nBatches = ceil(size(is,1)/maxBatchSize);

    for iBatch = 1:nBatches
        fprintf('Batch %d/%d\n',iBatch,nBatches);

        start = (iBatch-1)*maxBatchSize + 1;
        stop = min(size(is, 1), iBatch*maxBatchSize);
        thisBatchSize = stop-start+1;

        directories = dirs{start:stop};

        % perform the classification
        spmd(thisBatchSize)
            tmpresults = binary_log_regression(directories{labindex});
            tmpresults = rmfield(tmpresults,'features');
            tmpresults = rmfield(tmpresults,'y_hat');
        end
        fprintf('results computed\n')

        % report the results
        for i = 1:thisBatchSize
            results(start+i-1) = tmpresults{i};
            fprintf('%d: %.3f %.3f\n',i, results(i).pr_auc, results(i).roc_auc);
        end
        clear tmpresults filenames;
        fprintf('results loaded\n')
    end
    fprintf('generating final return value\n')
    results = struct2table(results(:));
    fprintf('evaluation complete\n')
end

