function process_single_data( train_x, train_y, subIdx, chanlocs )

x = train_x;
y = train_y;

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
train_x = reshape(train_x_freq, [64, size(train_x_freq, 1)/64, 64]);
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

test_x = reshape(test_x_freq, [64, size(test_x_freq, 1)/64, 64]);
test_x = permute(test_x, [2, 1, 3]);

train_x = permute(train_x, [2, 3, 4, 1]);
test_x = permute(test_x, [2, 3, 4, 1]);
test_x = single(test_x);
train_x = single(train_x);

save(['RSVP_X2_S' num2str(subIdx, '%02i') '_FREQ_CH64.mat'],...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');

%% raw
train_x = x;
train_y = y;
train_y(train_y == 4) = 0;
train_y(train_y == 5) = 1;

test_x = train_x(:, :, train_epoch+1:end);
test_y = train_y(train_epoch+1:end);
train_x = train_x(:, :, 1:train_epoch);
train_y = train_y(1:train_epoch);
test_y = test_y';
train_y = train_y';

test_x = permute(test_x, [1, 2, 4, 3]);
train_x = permute(train_x, [1, 2, 4, 3]);

save(['RSVP_X2_S' num2str(subIdx, '%02i') '_RAW_CH64.mat'],...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');

%% normalize
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

[~, mu, sigma] = zscore(train_x);
train_x = normalize(train_x, mu, sigma);
test_x = normalize(test_x, mu, sigma);

test_x = reshape(test_x, [length(test_y), 64, 64]);
test_x = permute(test_x, [2, 3, 4, 1]);
train_x = reshape(train_x, [length(train_y), 64, 64]);
train_x = permute(train_x, [2, 3, 4, 1]);

save(['RSVP_X2_S' num2str(subIdx, '%02i') '_NORM_CH64.mat'],...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');

end

