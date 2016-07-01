function PSD2 = bow_TFA(Y2,parameter)

% Calculate Frequency Values for components
frequencies = logspace(log10(parameter.PSD_frequencies_width(1)),...
    log10(parameter.PSD_frequencies_width(2)), parameter.PSD_frequencies_no);
PSD2=cell(1,2);


%-----------------------    First dataset     ----------------------------
% Extract data and pre-allocate results
Y = Y2{1};
[noChannel, noTime] = size(Y);
PSD = zeros(noChannel,parameter.PSD_frequencies_no,noTime);

% Wavelet transform
[wavelet,~,~,~] = dftfilt3(frequencies, [0.3 12], parameter.sampling_frequency);
for c=1:noChannel
    for w = 1:parameter.PSD_frequencies_no
        temp = conv(Y(c,:), wavelet{w}, 'same');
            singleEpochPower = squeeze(abs(temp) .^2);
            ds = singleEpochPower(1:parameter.PSD_down_sampling:end);
            PSD(c,w, :) = ds;
    end
end

% log PSD
PSD = log(PSD);

% Save result
PSD2{1} = PSD;

%-----------------------    Second dataset     ----------------------------
% Extract data and pre-allocate results
Y = Y2{2};
[noChannel, noTime] = size(Y);
PSD = zeros(noChannel,parameter.PSD_frequencies_no,noTime);

% Wavelet transform
[wavelet,~,~,~] = dftfilt3(frequencies, [0.3 12], parameter.sampling_frequency);
for c=1:noChannel
    for w = 1:parameter.PSD_frequencies_no
        temp = conv(Y(c,:), wavelet{w}, 'same');
            singleEpochPower = squeeze(abs(temp) .^2);
            ds = singleEpochPower(1:parameter.PSD_down_sampling:end);
            PSD(c,w, :) = ds;
    end
end

% log PSD
PSD = log(PSD);

% Save result
PSD2{2} = PSD;
end


