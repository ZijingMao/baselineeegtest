function [ montageIdx ] = mapper_idx_by_labels( fromChan, toChan )

chanSize = length(toChan);
fromChanSize = length(fromChan);

montageIdx = zeros(chanSize, 1);

for chanIdx = 1:chanSize
    currChanlabels = toChan(chanIdx).labels;
    for idx = 1:fromChanSize
        currCmpChanlabels = fromChan(idx).labels;
        if strcmpi(currCmpChanlabels, currChanlabels)
            montageIdx(chanIdx) = idx;
        end
    end
end

end

