function process_single_data_power( train_x, train_y, subIdx, chanlocs )

%% freq
train_y(train_y == 4) = 0;
train_y(train_y == 5) = 1;

total_epoch = length(train_y);
if total_epoch-10000 > 1000
    train_epoch = 10000;
elseif total_epoch-9000 > 1000
    train_epoch = 9000;
elseif total_epoch-8000 > 1000
    train_epoch = 8000;
elseif total_epoch-7000 > 1000
    train_epoch = 7000;
else
    train_epoch = 6000;
end
test_x = train_x(:, :, train_epoch+1:end);
test_y = train_y(train_epoch+1:end);
train_x = train_x(:, :, 1:train_epoch);
train_y = train_y(1:train_epoch);
test_y = test_y';
train_y = train_y';

%%
processed_EEG.trials = 1;
processed_EEG.chanlocs = chanlocs;
processed_EEG.xmin = 0;
processed_EEG.xmax = 1000;
processed_EEG.srate = 64;
processed_EEG.pnts = 64;
processed_EEG.icachansind = [];
processed_EEG.nbchan = 64;
processed_EEG.event = [];
processed_EEG.xmax = 1;
processed_EEG.icawinv = [];
processed_EEG.icaweights = [];
processed_EEG.icasphere = [];
processed_EEG.icaact = [];
processed_EEG.icachansind = [];
processed_EEG.filepath = [];
processed_EEG.filename = [];
processed_EEG.setname = [];

train_x_freq = [];
for idx = 1:length(train_y)
    a = squeeze(train_x(:, :, idx));
    processed_EEG.data = a;
    
%     curr_fig = figure;
    % the newtimef() could not provide high resolution result, try psd
%     [P,~,~,~,freqs,~,~,~,~] = ...
%         newtimef( processed_EEG.data(1,:), processed_EEG.pnts, ...
%         [processed_EEG.xmin processed_EEG.xmax*1000], ...
%         processed_EEG.srate, [3 0.5] ,...
%         'baseline',0,'plotphase','off','padratio',1, 'freqs', [5, 6]);
%     close(curr_fig);
    
    [ PSD ] = get_psd( processed_EEG, 5, 6, 5 );
    freq_spectra_data = squeeze(mean(PSD, 2));
    
    train_x_freq = cat(1, train_x_freq, freq_spectra_data(:, 1:64));
end
train_x = reshape(train_x_freq, [64, size(train_x_freq, 1)/64, 64]);
train_x = permute(train_x, [2, 1, 3]);

test_x_freq = [];
for idx = 1:length(test_y)
    a = squeeze(test_x(:, :, idx));
    processed_EEG.data = a;
    
    [ PSD ] = get_psd( processed_EEG, 5, 6, 5 );
    freq_spectra_data = squeeze(mean(PSD, 2));
    
    test_x_freq = cat(1, test_x_freq, freq_spectra_data(:, 1:64));
end

test_x = reshape(test_x_freq, [64, size(test_x_freq, 1)/64, 64]);
test_x = permute(test_x, [2, 1, 3]);

train_x = permute(train_x, [2, 3, 4, 1]);
test_x = permute(test_x, [2, 3, 4, 1]);
test_x = single(test_x);
train_x = single(train_x);

save(['RSVP_X2_S' num2str(subIdx, '%02i') '_PSD_CH64.mat'],...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');

end

