function idxs = index1DBlocks(m,rSize,cSize,blocks)
% m: the matrix being indexed
% rSize: the number of rows in each block
% cSize: the number of columns in each block
% blocks: a indexed (not subscripted) list of blocks, where sorting is in 
%   column-major order, as in the rest of MATLAB
    [r,c] = size(m);
    assert((rem(r,rSize) == 0 && c == cSize), 'index1DBlocks: array is not composed of blocks');
    nBlockRows = r/rSize;
    assert((sum(blocks > nBlockRows)) == 0, 'index1DBlocks: too many blocks');
    startRowsInBlocks = (reshape(blocks,[],1)-1)*rSize;
    allRowsInBlocks = repmat(startRowsInBlocks,1,rSize) + repmat(1:rSize,length(blocks),1);
    allRowsInBlocksVector = sort(reshape(allRowsInBlocks,[],1),'ascend');
    allIndsInBlocks = repmat(allRowsInBlocksVector,1,cSize) + repmat((0:(cSize-1))*r,length(allRowsInBlocksVector),1);
    idxs = reshape(allIndsInBlocks,[],1);
end
