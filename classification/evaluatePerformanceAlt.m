function results = evaluatePerformanceAlt( ...
  xTr,yTr,xTe,yTe,cv,options)
% function [top1,top5,models] = evaluatePerformanceAlt( ...
%   xTr,yTr,xTe,yTe,cv,method,options)
%
% Give top-1 and top-5 scores using cross-validation
%
% xTr: [nExamples nFeatures] array, the training feature values
% yTr: [nExamples nClasses] array, the class labels of examples in xTr
% xTe: [nExamples nFeatures] array, the testing feature values
% yTe: [nExamples nClasses] array, the class labels of examples in xTe
% cv: cell array of vectors, the train/test splits, where 1 = train, 0 = ignore
% options: options for the classifier
%
% top1: [nClasses, nTrainingExamples, nRuns] array, the top-1 performance
% top5: [nClasses, nTrainingExamples, nRuns] array, the top-5 performance
% models: [nClasses, nTrainingExamples, nRuns] cell, the classifiers

    [nTrainingExamples,nRuns] = size(cv);

    TrainingExamplesPerCategory = zeros(nTrainingExamples*nRuns,1);
    Split = zeros(nTrainingExamples*nRuns,1);
    Top1 = zeros(nTrainingExamples*nRuns,1);
    Top5 = zeros(nTrainingExamples*nRuns,1);
    Run = zeros(nTrainingExamples*nRuns,1);
    Model = cell(nTrainingExamples*nRuns,1);
    
    nGPUs = options.nGPUs;
    nBatches = ceil(nRuns/nGPUs);

    % convert the training labels
    [yTr,~] = ind2sub(size(yTr'),find(yTr'));
    [yTe,~] = ind2sub(size(yTe'),find(yTe'));

    count = 1;

    for iTrain = nTrainingExamples:-1:1
        for iBatch = 1:nBatches

            start = 1+(iBatch-1)*nGPUs;
            stop = min(iBatch*nGPUs,nRuns);
            nGPUsNeeded = stop-start+1;

            % write the data to disk
            for iGPU = 1:nGPUsNeeded

                % where will we store the data?
                final_dir{iGPU} = [options.dir '_' num2str(iTrain) '_' num2str(start+iGPU-1) '/'];
                ensureDir(final_dir{iGPU});
                chosen_items = cv{iTrain,start+iGPU-1};

                if ~exist([final_dir{iGPU} 'data.mat'],'file') || ~exist([final_dir{iGPU} 'results.mat'],'file')
                    % write training data
                    half = sum(cv{iTrain,start+iGPU-1});
                    if half > (2147483647/size(xTr,2)) % hack!
                        chosen_items = find(cv{iTrain,start+iGPU-1});
                        first_half = chosen_items(1:half);
                        second_half = chosen_items((half+1):end);
                        train_order = writeHDF5(xTr(first_half,:), ...
                                               yTr(first_half), ...
                                               [final_dir{iGPU} 'train1.h5']);
                        train_order = writeHDF5(xTr(second_half,:), ...
                                               yTr(second_half), ...
                                               [final_dir{iGPU} 'train2.h5']);
                    else
                        train_order = writeHDF5(xTr(cv{iTrain,start+iGPU-1},:), ...
                                               yTr(cv{iTrain,start+iGPU-1}), ...
                                               [final_dir{iGPU} 'train.h5']);
                    end

                    % write testing data
                    test_order = writeHDF5(xTe, ...
                                          yTe, ...
                                          [final_dir{iGPU} 'test.h5']);

                    % write these so we don't have to duplicate the feature data
                    file = [final_dir{iGPU} 'data.mat'];
                    save(file,'train_order','test_order','chosen_items');
                end
            end

            % run the classifiers
            spmd(nGPUsNeeded)
                if ~exist([final_dir{labindex} 'results.mat'],'file')
                    system(['LD_LIBRARY_PATH=/usr/lib/:/usr/local/lib/:/usr/local/cuda/lib:/usr/local/cuda/lib64 ' ...
                            'python mnlr.py ' num2str(int32(labindex-1)) ' ' final_dir{labindex} ' &> ' final_dir{labindex} 'log.log']);
                end
            end

            for iGPU = 1:nGPUsNeeded
                load([final_dir{iGPU} 'results.mat'],'top_1','top_5');
                iRun = start+iGPU-1;
                Model{count} = final_dir{iGPU};
                Top1(count) = top_1;
                Top5(count) = top_5;
                Run(count) = iRun;
                TrainingExamplesPerCategory(count) = sum(cv{iTrain,iRun});
                fprintf('%d %d: top1=%.3f top5=%.3f\n',TrainingExamplesPerCategory(count),Run(count),top_1,top_5);
                count = count+1;
            end
        end
    end
    results = table(TrainingExamplesPerCategory,Run,Top1,Top5,Model);
end

function order = writeHDF5(xs,ys,file)
    if ~exist(file,'file')
        % shuffle the data
        order = randperm(length(ys));
        shuffledXs = xs(order,:);
        shuffledYs = ys(order)-1; % subtract one for Python's 0-indexing

        % save the training/testing data
        h5create(file,'/data',size(shuffledXs'));
        h5write(file,'/data',shuffledXs');
        h5create(file,'/label',size(shuffledYs'));
        h5write(file,'/label',single(shuffledYs'));
    end
end
