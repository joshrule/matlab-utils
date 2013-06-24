function plotResponseHistograms(nSizesPerClass,nPatchesPerSize,nClasses,patchSizes,c2r)
    for iClass = 1:nClasses % for each class
        classStart = nSizesPerClass*nPatchesPerSize*(iClass-1)+1;
        for iSize = 1:nSizesPerClass % for each patch size
            sizeStart = classStart+nPatchesPerSize*(iSize-1);
            sizeEnd = sizeStart + nPatchesPerSize-1;
            fprintf('%d %d\n', sizeStart,sizeEnd);
            clf;
            f = figure();
            hist(reshape(c2r(sizeStart:sizeEnd,:),[],1),40);
            % plot histogram of patch outputs 
            xlabel('patch Activations');
            ylabel('# patches');
            title(['patch activation histogram class: ' num2str(iClass) ' size: ' num2str(patchSizes(1,iSize)')]);
            fixFonts;
            print(f, '-dpng', ['activation-histogram-' num2str(iClass) '-' num2str(patchSizes(1,iSize)) '.png']);
        end
    end
end


