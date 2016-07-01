function [ PSD ] = get_psd( PSD_EEG, lowFreq, highFreq, freqNum )

[ frequencies ] = define_wavelet_freq( lowFreq, highFreq, freqNum );

[wavelet,~,~,~] = dftfilt3(frequencies, [3 6], PSD_EEG.srate);

PSD = zeros(PSD_EEG.nbchan, freqNum, PSD_EEG.pnts, PSD_EEG.trials);

for c = 1:PSD_EEG.nbchan
    for w = 1:freqNum
        for epoch = 1:PSD_EEG.trials
            singleEpochPower = ...
                squeeze(abs(conv(PSD_EEG.data(c,:, epoch), wavelet{w}, 'same')) .^2);
            ds=singleEpochPower(1:1:PSD_EEG.pnts);
            PSD(c,w, :, epoch) = ds;
        end
    end
end

end

