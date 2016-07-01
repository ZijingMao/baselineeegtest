function [ idxChan5Kernel ] = convert_chan2idx( mapperChan5Kernel, chanCell )

[chanSize, kernSize] = size(mapperChan5Kernel);
assert(length(chanCell) == chanSize, 'Please check the channel location');
idxChan5Kernel = zeros(chanSize, kernSize);

% convert to lower case
for idx_chan = 1:chanSize
    chanCell{idx_chan} = lower(chanCell{idx_chan});
    for idx_kern = 1:kernSize
        mapperChan5Kernel{idx_chan, idx_kern} = ...
            lower(mapperChan5Kernel{idx_chan, idx_kern});
    end
end

for idx_chan = 1:chanSize
    for idx_kern = 1:kernSize
        IndexC = ismember(chanCell, mapperChan5Kernel{idx_chan, idx_kern});
        Index = find(IndexC==1);
        if isempty(Index)
            Index = 0;
        end
        idxChan5Kernel(idx_chan, idx_kern) = Index;
    end
end

end

