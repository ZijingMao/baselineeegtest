start_milisec = 200;
end_milisec = 400;

part_milisec = 1/64*1000;

start_point = floor(start_milisec/part_milisec);
end_point = ceil(end_milisec/part_milisec);

train_x = train_x(:, start_point:end_point);
test_x = test_x(:, start_point:end_point);

%%
train_x_part = train_x;
test_x_part = test_x;

load('RSVP_X2_S02_NORM_CH64.mat', 'test_x', 'train_x')
test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);

train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

train_x = cat(2, train_x, train_x_part);
test_x = cat(2, test_x, test_x_part);

aucBLDA_COM_raw	= train_classifier(train_x, train_y, test_x, test_y, 'BLDA');
aucBag_COM_raw	= train_classifier(train_x, train_y, test_x, test_y, 'Bag');
