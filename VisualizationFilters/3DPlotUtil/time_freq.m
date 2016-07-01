function TF_class = time_freq(class_data)
%TIME_FREQ Summary of this function goes here
%   Detailed explanation goes here

%----------------- CONFIGURE AND USE, JIA'S FUNCTION --------------------
% Set up parameters to perfomr Jia's Method 
parameter.PSD_frequencies_width=[2,30]; 
parameter.PSD_frequencies_no=10; 
parameter.PSD_down_sampling=1; 
parameter.sampling_frequency=256; 
parameter.log_PSD='Y'; 
parameter.PSD_normalization=0; 
parameter.start_time=1; 
[~, parameter.end_time] = size(class_data);

% Generate Cell for A & B Sections
Y2 = cell(1,1);
Y2{1} = class_data;

% setup wavelet transform parameters
frequencies = logspace(log10(parameter.PSD_frequencies_width(1)),...
    log10(parameter.PSD_frequencies_width(2)), parameter.PSD_frequencies_no);

Y=Y2{1};
% setup the space
noChannel=size(Y,1);
noEvent=size(Y,3);
noTime=size(Y,2);
PSD=zeros(noChannel,parameter.PSD_frequencies_no,...
    (noTime-1)/parameter.PSD_down_sampling+1,noEvent);

% wavelet transform
[wavelet,~,~,~] = dftfilt3(frequencies, [3 6],...
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

TF_class = PSD;




end

