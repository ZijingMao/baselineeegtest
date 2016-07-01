function [montageIdx] = slide_montage(chanlocs, kernelSize)
% chanlocs is the channel location information that used to design montage
% kernelSize is the montage size that used for spatial filtering

chanSize = length(chanlocs);

%% calculate the channel distance for channel 1
montageIdx = zeros(chanSize, kernelSize);

for chanIdx = 1:chanSize
    currChan = chanlocs(chanIdx);
    dis2currChan = zeros(chanSize, 1);
    for idx = 1:chanSize
        dis2currChan(idx) = cal_distance(currChan, chanlocs(idx));
    end
    [~, sortChanIdx] = sort(dis2currChan);
    % take the first kernelSize channels
    currKernelIdx = sortChanIdx(1:kernelSize);
    montageIdx(chanIdx,:) = currKernelIdx;
end

end