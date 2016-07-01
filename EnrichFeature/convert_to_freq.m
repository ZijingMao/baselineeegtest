% load your test and train data
load('D:\20160527_RSVP_DATASET\RSVP_X2_S01_RAW_CH30.mat');

subIdx = 1;
test_x = squeeze(test_x);
train_x = squeeze(train_x);
test_y = test_y';
train_y = train_y';

processed_EEG.trials = 1;
processed_EEG.chanlocs = chanlocs64;  % select channels loaded from the source location
processed_EEG.xmin = 0;
processed_EEG.xmax = 1000;
processed_EEG.srate = 64;
processed_EEG.pnts = 64;
processed_EEG.icachansind = [];
processed_EEG.nbchan = 30;  % select channels loaded from the source location
processed_EEG.event = [];
processed_EEG.xmax = 1;

train_x_freq = [];
for idx = 1:length(train_y)
    a = squeeze(train_x(:, :, idx));
    processed_EEG.data = a;
    curr_fig = figure;
    [freq_spectra_data, ~, ~, ~] = pop_spectopo(processed_EEG, 1, ...
        [processed_EEG.xmin (processed_EEG.xmax*1000)], ...
        'EEG' , 'freqrange', [0.5, 30], 'electrodes', 'off');
    close(curr_fig);
    train_x_freq = cat(1, train_x_freq, freq_spectra_data(:, 1:64));
end
train_x = reshape(train_x_freq, ...
    [processed_EEG.nbchan, size(train_x_freq, 1)/processed_EEG.nbchan, processed_EEG.srate]);
train_x = permute(train_x, [2, 1, 3]);

test_x_freq = [];
for idx = 1:length(test_y)
    a = squeeze(test_x(:, :, idx));
    processed_EEG.data = a;
    curr_fig = figure;
    [freq_spectra_data, ~, ~, ~] = pop_spectopo(processed_EEG, 1, ...
        [processed_EEG.xmin (processed_EEG.xmax*1000)], ...
        'EEG' , 'freqrange', [0.5, 30], 'electrodes', 'off');
    close(curr_fig);
    test_x_freq = cat(1, test_x_freq, freq_spectra_data(:, 1:64));
end

test_x = reshape(test_x_freq, ...
    [processed_EEG.nbchan, size(test_x_freq, 1)/processed_EEG.nbchan, processed_EEG.srate]);
test_x = permute(test_x, [2, 1, 3]);

train_x = permute(train_x, [2, 3, 4, 1]);
test_x = permute(test_x, [2, 3, 4, 1]);
test_x = single(test_x);
train_x = single(train_x);

save(['RSVP_S' num2str(subIdx, '%02i') '_FREQ_CH30.mat'],...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');