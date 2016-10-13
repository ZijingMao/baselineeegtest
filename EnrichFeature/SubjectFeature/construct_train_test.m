function [ tmp_train_x, tmp_train_y, ...
    tmp_test_x, tmp_test_y] = construct_train_test( x, y, steps, idx )

tmp_train_x = x(:, :, 1:steps);
%tmp_train_y = ones(steps, 1) * idx;
 tmp_train_y = y(1:steps);
tmp_test_x = x(:, :, steps+1:end);
%tmp_test_y = ones(length(y)-steps, 1) * idx;
 tmp_test_y = y(steps+1:end);

end

