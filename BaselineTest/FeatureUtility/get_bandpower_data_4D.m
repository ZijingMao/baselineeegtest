function [ subPowerData ] = get_bandpower_data_4D( dataClass,  subID )

fs = 128;
freqRange = [4, 8; 8, 10; 10, 12; 12, 30; 30, 50];
freqNum = size(freqRange, 1);

subData = dataClass{subID};
[epochNum, ~, chanNum, timeNum] = size(subData);
subPowerData = zeros([epochNum, freqNum, chanNum, timeNum]);
for epoch = 1:epochNum
    for chan = 1:chanNum
        for time = 1:timeNum
            currentChanData = squeeze(subData(epoch, :, chan, timeNum));
            ptot = bandpower(currentChanData,fs, [freqRange(1) freqRange(end)]);
            for freq = 1:freqNum            
                pband = bandpower(currentChanData, fs, freqRange(freq, :));            
                per_power = pband/ptot;
                subPowerData(epoch, freq, chan, time) = per_power;
            end
        end
    end
end

end

