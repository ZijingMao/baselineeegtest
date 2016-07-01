function [ frequencies ] = define_wavelet_freq( lowFreq, highFreq, freqNum )

frequencies = logspace(log10(lowFreq),...
    log10(highFreq), freqNum);

end

