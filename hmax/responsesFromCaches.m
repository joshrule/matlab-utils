function [r,labels] = responsesFromCaches(caches,name)
    r = []; labels = [];
    for iClass = 1:size(caches,1)
        k = [];
    	for iFile = 1:size(caches,2)
            tmp = load(caches{iClass},name);
            newK = getfield(tmp,name);
            k = [k; newK];
            clear tmp newK;
        end
        r = [r k];
	labels = blkdiag(labels, ones(1,size(k,2)));
    end
end
