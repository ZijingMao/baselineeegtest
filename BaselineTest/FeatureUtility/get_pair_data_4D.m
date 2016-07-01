function [ pairData ] = get_pair_data_4D( dataClass,  subID, emotion_chan_lbl)

subData = dataClass{subID};
[epochNum, freqNum, ~, timeNum] = size(subData);
pairNum = sum(emotion_chan_lbl~=0)/2;
pairData = zeros([epochNum, freqNum, pairNum, timeNum]);
for epoch = 1:epochNum
    for i = 1:pairNum
        for time = 1:timeNum
            pair_idx = find(emotion_chan_lbl==i);
            currentChanData1 = squeeze(subData(epoch, :, pair_idx(1), time));
            currentChanData2 = squeeze(subData(epoch, :, pair_idx(2), time));
            pairData(epoch, :, i, time) = currentChanData1 - currentChanData2;
        end
    end
end

end

