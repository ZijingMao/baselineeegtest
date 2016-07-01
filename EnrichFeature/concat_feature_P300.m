function concat_feature_P300(subIdx, type1)

x_train = [];y_train = [];x_test = [];y_test = [];

train_x = [];train_y = [];test_x = [];test_y = [];
load(['RSVP_X2_S' num2str(subIdx, '%02i') '_' type1 '_CH64.mat']);
x_train = cat(3, x_train, train_x);
x_test = cat(2, x_test, test_x);

pnt = 64;

start_time = 0.200;
end_time = 0.400;
start_point = floor(pnt*start_time);
end_point = ceil(pnt*end_time);

train_tmp_x = train_x(:, start_point:end_point, :, :);
test_tmp_x = test_x(:, start_point:end_point, :, :);

train_x = zeros(size(train_x));
test_x = zeros(size(test_x));

train_x(:, start_point:end_point, :, :) = train_tmp_x;
test_x(:, start_point:end_point, :, :) = test_tmp_x;

x_train = cat(3, x_train, train_x);
x_test = cat(3, x_test, test_x);

train_x = x_train;test_x = x_test;

save(['RSVP_X2_S' num2str(subIdx, '%02i') '_' type1 'P300_CH64.mat'],...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');

end