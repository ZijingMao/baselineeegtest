function [ pxx1_log, pxx2_log, pxx3_log, pxx4_log, pxx5_log ]...
            = power_spec_data( x, winLen, includeDelta )

x=x';% each row of the epoch
segmentLength=hanning(winLen);

fs=winLen;

if includeDelta
    [pxx1,f1] = pwelch(x,segmentLength,[],0.5:0.01:4,fs);
end

[pxx2,f2] = pwelch(x,segmentLength,[],4:0.001:8,fs);
[pxx3,f3] = pwelch(x,segmentLength,[],8:0.001:13,fs);
[pxx4,f4] = pwelch(x,segmentLength,[],13:0.001:30,fs);
[pxx5,f4] = pwelch(x,segmentLength,[],30:0.001:50,fs);

pxx1_log=10*log10(pxx1);
pxx2_log=10*log10(pxx2);
pxx3_log=10*log10(pxx3);
pxx4_log=10*log10(pxx4);
pxx5_log=10*log10(pxx5);

end

