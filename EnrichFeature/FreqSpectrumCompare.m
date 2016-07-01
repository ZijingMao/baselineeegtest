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

lower = -80; upper = 50;
target_idx = find(train_y==1);
nontarget_idx = find(train_y==0);
total_size = 5;

%%
currfig = figure;
a = train_x(nontarget_idx, :, :);
a = mean(a, 1);
a = squeeze(a);
processed_EEG.data = a;
GenFreqSpectrumData;
subplot(1, 2, 1);
colormap(jet); imagesc(freq_spectra_data); caxis([lower, upper]);
title('Collection of non-target');

a = train_x(target_idx, :, :);
a = mean(a, 1);
a = squeeze(a);
processed_EEG.data = a;
GenFreqSpectrumData;
subplot(1, 2, 2);
colormap(jet); imagesc(freq_spectra_data); caxis([lower, upper]);
title('Collection of target');
saveas(currfig, 'average.png');

%%
for start_point = 1:5:500
    currfig = figure;
    for idx = 1:total_size
        a = squeeze(train_x(nontarget_idx(start_point+idx-1), :, :));
        processed_EEG.data = a;
        GenFreqSpectrumData;
        subplot(total_size, 2, (idx-1)*2+1);
        colormap(jet); imagesc(freq_spectra_data); caxis([lower, upper]);
        title(['epoch ' num2str(idx, '%04i') ' of non-target']);
        
        a = squeeze(train_x(target_idx(start_point+idx-1), :, :));
        processed_EEG.data = a;
        GenFreqSpectrumData;
        subplot(total_size, 2, idx*2);
        colormap(jet); imagesc(freq_spectra_data); caxis([lower, upper]);
        title(['epoch ' num2str(idx, '%04i') ' of target']);
    end
    
    saveas(currfig, [num2str(start_point) '.png']);
    close(currfig);
end

%%
train_x_freq = [];
for idx = 1:length(train_y)
    a = squeeze(train_x(idx, :, :));
    processed_EEG.data = a;
    GenFreqSpectrumData;
    train_x_freq = cat(1, train_x_freq, freq_spectra_data(:, 1:64));
end
train_x = reshape(train_x_freq, [64, size(train_x_freq, 1)/64, 64]);
train_x = permute(train_x, [2, 1, 3]);

test_x_freq = [];
for idx = 1:length(test_y)
    a = squeeze(test_x(idx, :, :));
    processed_EEG.data = a;
    GenFreqSpectrumData;
    test_x_freq = cat(1, test_x_freq, freq_spectra_data(:, 1:64));
end
test_x = reshape(test_x_freq, [64, size(test_x_freq, 1)/64, 64]);
test_x = permute(test_x, [2, 1, 3]);

aucBLDA	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag 	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');

%% 
train_x_freq = train_x;
test_x_freq = test_x;

load('RSVP_X2_S02_NORM_CH64.mat', 'test_x', 'train_x')
test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);

train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

train_x = cat(2, train_x, train_x_freq);
test_x = cat(2, test_x, test_x_freq);

aucBLDA_COM_raw	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag_COM_raw	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');

