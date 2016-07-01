function [aucBLDA_norm, aucBag_norm, ...
    aucBLDA_raw, aucBag_raw, ...
    aucBLDA_freq, aucBag_freq, ...
    aucBLDA_freq_raw, aucBag_freq_raw, ...
    aucBLDA_freq_norm, aucBag_freq_norm] = all_feature_classifier(subIdx)
%%
load(['RSVP_X2_S' num2str(subIdx, '%02i') '_NORM_CH64.mat']);

test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

aucBLDA_norm	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag_norm 	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');

%%
load(['RSVP_X2_S' num2str(subIdx, '%02i') '_RAW_CH64.mat']);

test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

aucBLDA_raw	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag_raw 	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');

%%
load(['RSVP_X2_S' num2str(subIdx, '%02i') '_FREQ_CH64.mat']);

test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

aucBLDA_freq	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag_freq 	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');

%%
load(['RSVP_X2_S' num2str(subIdx, '%02i') '_FREQ_CH64.mat']);

test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

train_x_freq = train_x;
test_x_freq = test_x;

load(['RSVP_X2_S' num2str(subIdx, '%02i') '_RAW_CH64.mat']);
test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

train_x = cat(2, train_x, train_x_freq);
test_x = cat(2, test_x, test_x_freq);

aucBLDA_freq_raw	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag_freq_raw 	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');

%%
load(['RSVP_X2_S' num2str(subIdx, '%02i') '_FREQ_CH64.mat']);

test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

train_x_freq = train_x;
test_x_freq = test_x;

load(['RSVP_X2_S' num2str(subIdx, '%02i') '_NORM_CH64.mat']);
test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

train_x = cat(2, train_x, train_x_freq);
test_x = cat(2, test_x, test_x_freq);

aucBLDA_freq_norm	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag_freq_norm	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');

end
