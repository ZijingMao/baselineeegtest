function PSD2=calculate_PSD_1(Y2,parameter)

% setup wavelet transform parameters
frequencies = logspace(log10(parameter.PSD_frequencies_width(1)),...
    log10(parameter.PSD_frequencies_width(2)), parameter.PSD_frequencies_no);
PSD2=cell(1,2);

Y=Y2{1};
% setup the space
noChannel=size(Y,1);
noEvent=size(Y,3);
noTime=size(Y,2);
PSD=zeros(noChannel,parameter.PSD_frequencies_no,...
    (noTime-1)/parameter.PSD_down_sampling+1,noEvent);

% wavelet transform
[wavelet,cycles,freqresol,timeresol] = dftfilt3(frequencies, [3 6],...
    parameter.sampling_frequency);
for c=1:size(Y,1)
    %disp(['Calculate PSD1: C',num2str(c)]);
    for w = 1:parameter.PSD_frequencies_no
        for epoch =1:size(Y, 3)
            temp = conv(Y(c,:, epoch), wavelet{w}, 'same');
            singleEpochPower = squeeze(abs(temp) .^2);
            ds=singleEpochPower(1:parameter.PSD_down_sampling:end);
            PSD(c,w, :, epoch) = ds;
        end;
    end
end

% log PSD
switch parameter.log_PSD
    case 'Y'
        PSD=log(PSD);
    otherwise
end

PSD2{1}=PSD;

return