cd('C:\Users\EEGLab\Documents\20160527_RSVP_DATASET')

load('X2RSVP64CHAN.mat')
load('C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration\EEGRoomPC\Zijing Mao\baselineeegtest\Source\ChannelSrc\chanlocs.mat', 'chanlocs64');
%%
parfor subIdx = 3:10
    
    train_x = x{subIdx};
    train_y = y{subIdx};
    
    process_single_data( train_x, train_y, subIdx, chanlocs64 );
    
end

%%
parfor subIdx = 1:10
    
    train_x = x{subIdx};
    train_y = y{subIdx};
    
    process_single_data_power( train_x, train_y, subIdx, chanlocs64 );
    
end

%%
parfor subIdx = 1:10
    %     process_single_data_p300( subIdx, 0 );
    %     process_single_data_p300( subIdx, 1 );
    process_single_data_p300( subIdx, 1.5 );
end

%%
for subIdx = 1:10
    
    [aucBLDA_norm(subIdx), aucBag_norm(subIdx), ...
        aucBLDA_raw(subIdx), aucBag_raw(subIdx), ...
        aucBLDA_freq(subIdx), aucBag_freq(subIdx), ...
        aucBLDA_freq_raw(subIdx), aucBag_freq_raw(subIdx), ...
        aucBLDA_freq_norm(subIdx), aucBag_freq_norm(subIdx)] = ...
        all_feature_classifier(subIdx);
    
end

std(aucBag_freq)   % 0.6586
mean(aucBag_norm)   % 0.6458
mean(aucBag_raw)    % 0.6446
mean(aucBag_freq_norm)  % 0.6799
mean(aucBag_freq_raw)   % 0.6861
std(aucBLDA_freq)  % 0.6747
mean(aucBLDA_norm)  % 0.7022
mean(aucBLDA_raw)   % 0.7016
mean(aucBLDA_freq_norm) % 0.6910
mean(aucBLDA_freq_raw)  % 0.7255

[h, p]=ttest(aucBLDA_freq_raw, aucBLDA_raw);

%%
for subIdx = 1:10
    
    %     [aucBLDA_P3000(subIdx), aucBag_P3000(subIdx)] = ...
    %         feature_classifier(subIdx, 'P3000');
    %     [aucBLDA_P3001(subIdx), aucBag_P3001(subIdx)] = ...
    %         feature_classifier(subIdx, 'P3001');
    %     [aucBLDA_PSD(subIdx), aucBag_PSD(subIdx)] = ...
    %         feature_classifier(subIdx, 'PSD');
    [aucBLDA_P30015(subIdx), aucBag_P30015(subIdx)] = ...
        feature_classifier(subIdx, 'P3001.5');
    
end

mean(aucBLDA_P3000)
mean(aucBLDA_P3001)
mean(aucBLDA_PSD)
mean(aucBag_P3000)
mean(aucBag_P3001)  % 0.5807
mean(aucBag_PSD)
mean(aucBLDA_P30015)    % 0.6512
mean(aucBag_P30015) % 0.6405


%%
for subIdx = 1:10
    
    [aucBLDA_P3000_RAW(subIdx), aucBag_P3000_RAW(subIdx)] = ...
        combine_feature_classifier(subIdx, 'P3000', 'RAW');
    [aucBLDA_P3001_RAW(subIdx), aucBag_P3001_RAW(subIdx)] = ...
        combine_feature_classifier(subIdx, 'P3001', 'RAW');
    [aucBLDA_PSD_RAW(subIdx), aucBag_PSD_RAW(subIdx)] = ...
        combine_feature_classifier(subIdx, 'PSD', 'RAW');
    
end

mean(aucBLDA_P3000_RAW) % 0.7013
mean(aucBLDA_P3001_RAW) % 0.7052
mean(aucBLDA_PSD_RAW)   % 0.5539
mean(aucBag_P3000_RAW)
mean(aucBag_P3001_RAW)
mean(aucBag_PSD_RAW)

%%
for subIdx = 1:10
    
    [aucBLDA_P3000_NORM(subIdx), aucBag_P3000_NORM(subIdx)] = ...
        combine_feature_classifier(subIdx, 'P3000', 'NORM');
    [aucBLDA_P3001_NORM(subIdx), aucBag_P3001_NORM(subIdx)] = ...
        combine_feature_classifier(subIdx, 'P3001', 'NORM');
    [aucBLDA_PSD_NORM(subIdx), aucBag_PSD_NORM(subIdx)] = ...
        combine_feature_classifier(subIdx, 'PSD', 'NORM');
    [aucBLDA_P30015_RAW(subIdx), aucBag_P30015_RAW(subIdx)] = ...
        combine_feature_classifier(subIdx, 'P3001.5', 'RAW');
    [aucBLDA_P30015_NORM(subIdx), aucBag_P30015_NORM(subIdx)] = ...
        combine_feature_classifier(subIdx, 'P3001.5', 'NORM');
    
end

mean(aucBLDA_P3000_NORM)    % 0.6757
mean(aucBLDA_P3001_NORM)    % 0.6953
mean(aucBLDA_PSD_NORM)      % 0.5384
mean(aucBag_P3000_NORM)     % 0.6502
mean(aucBag_P3001_NORM)     % 0.6508
mean(aucBag_PSD_NORM)       % 0.6488

mean(aucBLDA_P30015_RAW)    % 0.7168
mean(aucBag_P30015_RAW)     % 0.6719
mean(aucBLDA_P30015_NORM)   % 0.6858
mean(aucBag_P30015_NORM)    % 0.6697

%% variance

std(aucBLDA_raw)
std(aucBLDA_P3001_RAW)
std(aucBLDA_P30015_RAW)
std(aucBLDA_freq_raw)

std(aucBag_raw)
std(aucBag_P3001_RAW)
std(aucBag_P30015_RAW)
std(aucBag_freq_raw)


%%
parfor subIdx = 1:10
    concat_feature(subIdx, 'NORM', 'FREQ');
end

%%
parfor subIdx = 1:10
    concat_feature_P300(subIdx, 'RAW');
end

%%
parfor subIdx = 1:10
    concat_feature(subIdx, 'RAWP300', 'FREQ');
end

