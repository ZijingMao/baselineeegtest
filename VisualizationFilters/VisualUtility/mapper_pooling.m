function [ montageIdx ] = mapper_pooling( fromChan, toChan, kernelSize )

chanSize = length(toChan);
fromChanSize = length(fromChan);

%% calculate the channel distance for channel 1
montageIdx = zeros(chanSize, kernelSize);

for chanIdx = 1:chanSize
    currChan = toChan(chanIdx);
    dis2currChan = zeros(chanSize, 1);
    for idx = 1:fromChanSize
        dis2currChan(idx) = cal_distance(currChan, fromChan(idx));
    end
    [~, sortChanIdx] = sort(dis2currChan);
    % take the first kernelSize channels
    currKernelIdx = sortChanIdx(1:kernelSize);
    montageIdx(chanIdx,:) = currKernelIdx;
end

end

