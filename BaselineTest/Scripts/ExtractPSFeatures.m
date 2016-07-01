[~, ~, emotion_chan] = xlsread('emotion_channel_name.xlsx', 'B1:B32');


paired_chan = {'FP1', 'FP2'; 'AF3', 'AF4'; 'F3', 'F4'; ...
    'F7', 'F8'; 'FC5', 'FC6'; 'FC1', 'FC2'; 'C3', 'C4'; ...
    'T7', 'T8'; 'CP5', 'CP6'; 'CP1', 'CP2'; 'P3', 'P4'; ...
    'P7', 'P8'; 'PO3', 'PO4'; 'O1', 'O2'};

emotion_chan_lbl = zeros(length(emotion_chan), 1);

for i = 1:14
    for j = 1:2
        for pointer = 1:32
            if strcmpi(paired_chan{i, j}, emotion_chan{pointer})
                emotion_chan_lbl(pointer) = i;   
            end
        end
    end
end

%% this is the feature generated for paper 1
load('/home/zijing.mao/DEAPdataset/EEGEmotionExperiment/Data/Raw/unbalanced.mat');
parfor subID = 1:32
    [ powerDataA{subID} ] = get_bandpower_data( dataClassA,  subID );    
    [ powerDataB{subID} ] = get_bandpower_data( dataClassB,  subID );    
    [ powerDataC{subID} ] = get_bandpower_data( dataClassC,  subID );    
end
save('/home/zijing.mao/DEAPdataset/EEGEmotionExperiment/Data/PSFeatures/powerData.mat', ...
                'powerDataA', 'powerDataB', 'powerDataC');
            
            
load('/home/zijing.mao/DEAPdataset/EEGEmotionExperiment/Data/Raw/powerData.mat');
parfor subID = 1:32
    [ pairDataA{subID} ] = get_pair_data( powerDataA,  subID, emotion_chan_lbl);
    [ pairDataB{subID} ] = get_pair_data( powerDataB,  subID, emotion_chan_lbl);
    [ pairDataC{subID} ] = get_pair_data( powerDataC,  subID, emotion_chan_lbl);
end
save('/home/zijing.mao/DEAPdataset/EEGEmotionExperiment/Data/PSFeatures/powerPairData.mat', ...
                'pairDataA', 'pairDataB', 'pairDataC');
            
%% this is the feature generated for paper 2
timeLen = 128; % 1 second
dataClassA = [];
dataClassB = [];
dataClassC = [];
load('/home/zijing.mao/DEAPdataset/EEGEmotionExperiment/Data/Raw/unbalanced.mat');

%change the data into 4 dimension
parfor subID = 1:32
    dataClassA{subID} = reshape_4D(dataClassA{subID}, timeLen);
    dataClassB{subID} = reshape_4D(dataClassB{subID}, timeLen);
    dataClassC{subID} = reshape_4D(dataClassC{subID}, timeLen);
end

parfor subID = 1:32
    [ powerDataA{subID} ] = get_bandpower_data_4D( dataClassA,  subID );    
    [ powerDataB{subID} ] = get_bandpower_data_4D( dataClassB,  subID );    
    [ powerDataC{subID} ] = get_bandpower_data_4D( dataClassC,  subID );    
end
save('/home/zijing.mao/DEAPdataset/EEGEmotionExperiment/Data/PSFeatures/powerData4D.mat', ...
                'powerDataA', 'powerDataB', 'powerDataC');

parfor subID = 1:32
    [ pairDataA{subID} ] = get_pair_data_4D( powerDataA,  subID, emotion_chan_lbl);
    [ pairDataB{subID} ] = get_pair_data_4D( powerDataB,  subID, emotion_chan_lbl);
    [ pairDataC{subID} ] = get_pair_data_4D( powerDataC,  subID, emotion_chan_lbl);
end
save('/home/zijing.mao/DEAPdataset/EEGEmotionExperiment/Data/PSFeatures/powerPairData4D.mat', ...
                'pairDataA', 'pairDataB', 'pairDataC');
