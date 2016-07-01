function [ aucBLDA, aucBag ] = feature_classifier( subIdx, type )

train_x = [];
test_x = [];
train_y = [];
test_y = [];

switch type
    case 'P3000'
        load(['RSVP_X2_S' num2str(subIdx, '%02i') '_P3000_CH64.mat']);
    case 'P3001'
        load(['RSVP_X2_S' num2str(subIdx, '%02i') '_P3001_CH64.mat']);
    case 'P3001.5'
        load(['RSVP_X2_S' num2str(subIdx, '%02i') '_P3001.5_CH64.mat']);
    case 'PSD'
        load(['RSVP_X2_S' num2str(subIdx, '%02i') '_PSD_CH64.mat']);
end

test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);
train_x = reshape(train_x, [size(train_x, 1)*size(train_x, 2), size(train_x, 3)])';
test_x = reshape(test_x, [size(test_x, 1)*size(test_x, 2), size(test_x, 3)])';

aucBLDA	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag 	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');

end

