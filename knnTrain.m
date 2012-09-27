function w = knnTrain(examples,labels,k,alpha,tolerance)
    if (nargin < 5) tolerance = 10^-5; end;
    if (nargin < 4) alpha = .1; end;
    if (nargin < 3) k = length(unique(labels))+1; end;


    w = ones(1,k) ./ k;
    deltaW = w;
    nClasses = length(unique(labels));
    nExamples = length(labels);

    % construct B matrices
    B = zeros(nExamples,nClasses,k+1);
    B(:,:,k+1) = 1/k;
    neighbors = knnsearch(examples, examples, 'k',k);
    for iExamples = 1:nExamples
        for iK = 1:k
            kClass = labels(neighbors(iExample,iK));
            B(iExamples,kClass,iK) = 1;
        end
    end

    % hill climb
    while (norm(deltaW) > tolerance)
        w = w .+ deltaW;
        for iK = 1:k
            gradient = -(nExamples*exp(w(iK))/sum(exp(w));
            for iExamples = 1:nExamples
                gradient = gradient + (B(iExample,label(iExample),iK)*exp(w(iK)))/(sum(B(iExample,label(iExample),:))*sum(exp(w)))
            end
            deltaW(iK) = alpha * gradient;
        end
    end
