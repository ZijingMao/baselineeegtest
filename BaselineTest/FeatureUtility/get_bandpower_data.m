function [ subPowerData ] = get_bandpower_data( dataClass,  subID )

fs = 128;
freqRange = [4, 8; 8, 10; 10, 12; 12, 30; 30, 50];
freqNum = size(freqRange, 1);

subData = dataClass{subID};
[epochNum, chanNum, ~] = size(subData);
subPowerData = zeros([epochNum, chanNum, freqNum]);
for epoch = 1:epochNum
    for chan = 1:chanNum
        currentChanData = squeeze(subData(epoch, chan, :));
        ptot = bandpower(currentChanData,fs, [freqRange(1) freqRange(end)]);
        for freq = 1:freqNum            
            pband = bandpower(currentChanData, fs, freqRange(freq, :));            
            per_power = pband/ptot;
            subPowerData(epoch, chan, freq) = per_power;
        end
    end
end

end

