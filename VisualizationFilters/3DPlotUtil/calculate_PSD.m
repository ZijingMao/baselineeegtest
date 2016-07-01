function PSD2=calculate_PSD(Y2,parameter)

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

Y=Y2{2};
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
PSD2{2}=PSD;

% PSD normalization
switch parameter.PSD_normalization
    case 0
        %disp('No PSD normalization');
    case 1
        disp('whole epoch PSD normalization');
        disp('Normalize the power spectrum');
        [noC,noF,noS,noE]=size(PSD2{1});
        y1=PSD2{1};
        y2=PSD2{2};
        for iC=1:noC
            disp(['Normalization C',num2str(iC)]);
            for iF=1:noF
                for iE=1:noE
                    temp1=squeeze(y1(iC,iF,:,iE));
                    temp2=(temp1-mean(temp1))/std(temp1);
                    y1(iC,iF,:,iE)=temp2;
                    temp1=squeeze(y2(iC,iF,:,iE));
                    temp2=(temp1-mean(temp1))/std(temp1);
                    y2(iC,iF,:,iE)=temp2;                                  
                end
            end
        end
        PSD2{1}=y1;
        PSD2{2}=y2;        
    case 2
        disp('before 0s normalization');
        disp('Normalize the power spectrum');
        
        % find zero
        time=parameter.start_time:parameter.PSD_down_sampling/parameter.sampling_frequency:parameter.end_time;
        ID=find((time<-0.3).*(time>time(1)+0.3));
        
        % start
        [noC,noF,noS,noE]=size(PSD2{1});
        y1=PSD2{1};
        y2=PSD2{2};
        for iC=1:noC
            disp(['Normalization C',num2str(iC)]);
            for iF=1:noF
                for iE=1:noE
                    temp1=squeeze(y1(iC,iF,:,iE));
                    temp2=(temp1-mean(temp1(ID)))/std(temp1(ID));
                    y1(iC,iF,:,iE)=temp2;
                    temp1=squeeze(y2(iC,iF,:,iE));
                    temp2=(temp1-mean(temp1(ID)))/std(temp1(ID));
                    y2(iC,iF,:,iE)=temp2;                                  
                end
            end
        end
        PSD2{1}=y1;
        PSD2{2}=y2;        
end

return