function [ svm_featur_vect ] = SVM_featur_extract( x )

step = 0.1;
freqRange = [4, 8; 8, 10; 10, 12; 12, 30; 30, 50];
freqNum = size(freqRange, 1);

segmentLength=hanning(128);

fs=128;

for freq = 1:freqNum
    
    [pxx{freq},f{freq}] = pwelch(x,segmentLength,[],freqRange(freq, 1):step:freqRange(freq, 2),fs);

    pxx_log{freq}=10*log10(pxx{freq});

end


%% dominant peak finding
dom_peak = [];
dom_freq = [];
for freq = 1:freqNum
    [ v(freq), k(freq) ] = domin_peak_find( pxx_log{freq});
    
    dom_peak(freq) = v(freq);
    dom_freq(freq) = f{freq}(k(freq));

end

%% average power of dominant peak

for freq = 1:freqNum
    [ f_don(freq),f_up(freq) ] = up_down_frequency( pxx{freq},f{freq},k(freq) );
    if f_don(freq) == f_up(freq)
        pband(freq) =0;
    else
        pband(freq) = bandpower(pxx{freq},f{freq},[f_don(freq) f_up(freq)],'psd');
    end

end

%%  center of gravity of frequency CGF

for freq = 1:freqNum
    CGF(freq)= CGF_calc( pxx{freq},f{freq} );
end

%% frequency variability

for freq = 1:freqNum
    FV(freq)=freq_var( pxx{freq},f{freq});
end


%% cat all features
svm_featur_vect=[dom_freq,...
                 pband,...
                 CGF,...
                 FV];


end

