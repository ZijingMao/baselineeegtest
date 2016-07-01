function [ pairData ] = get_pair_data( dataClass,  subID, emotion_chan_lbl)

subData = dataClass{subID};
[epochNum, ~, freqNum] = size(subData);
pairNum = sum(emotion_chan_lbl~=0)/2;
pairData = zeros([epochNum, pairNum, freqNum]);
for epoch = 1:epochNum
    for i = 1:pairNum
        pair_idx = find(emotion_chan_lbl==i);
        currentChanData1 = squeeze(subData(epoch, pair_idx(1), :));
        currentChanData2 = squeeze(subData(epoch, pair_idx(2), :));
        pairData(epoch, i, :) = currentChanData1 - currentChanData2;
    end
end

end

