fold = 1;

%% set driving dataset
load('I:\level2_256Hz_epoch\DataSets\DRIVING64CHAN.mat');

test_x = [];test_y = [];
for i = 1:10
    test_x = cat(3, test_x, x{i});
    test_y = cat(1, test_y, y{i});
end
train_x = [];train_y = [];
for i = 11:318
    train_x = cat(3, train_x, x{i});
    train_y = cat(1, train_y, y{i});
end

test_len = length(test_y);
train_len = length(train_y);

%% set rsvp testing dataset
load('I:\level2_256Hz_epoch\DataSets\X2RSVP64CHAN.mat');

test_rsvp_x = x{fold};
test_rsvp_y = y{fold};

findy0 = find(test_rsvp_y == 4);
findy1 = find(test_rsvp_y == 5);

if length(findy0) ~= length(findy1)
    error('unbalanced data');
end

permLen  = randperm(length(findy0));
findy0 = findy0(permLen);
findy1 = findy1(permLen);

test_rsvp_x0 = test_rsvp_x(:, :, findy0(1:test_len/2));
test_rsvp_x1 = test_rsvp_x(:, :, findy1(1:test_len/2));
test_rsvp_y0 = test_rsvp_y(findy0(1:test_len/2));
test_rsvp_y1 = test_rsvp_y(findy1(1:test_len/2));

test_x = cat(3, test_x, test_rsvp_x0, test_rsvp_x1);
test_y = cat(1, test_y, test_rsvp_y0, test_rsvp_y1);

%% set rsvp training dataset
train_rsvp_x = []; train_rsvp_y = [];
for i = 1:length(x)
    if i ~= fold
        train_rsvp_x = cat(3, train_rsvp_x, x{fold});
        train_rsvp_y = cat(1, train_rsvp_y, y{fold});
    end
end

findy0 = find(train_rsvp_y == 4);
findy1 = find(train_rsvp_y == 5);

if length(findy0) ~= length(findy1)
    error('unbalanced data');
end

permLen  = randperm(length(findy0));
findy0 = findy0(permLen);
findy1 = findy1(permLen);

train_rsvp_x0 = train_rsvp_x(:, :, findy0(1:train_len/2));
train_rsvp_x1 = train_rsvp_x(:, :, findy1(1:train_len/2));
train_rsvp_y0 = train_rsvp_y(findy0(1:train_len/2));
train_rsvp_y1 = train_rsvp_y(findy1(1:train_len/2));

train_x = cat(3, train_x, train_rsvp_x0, train_rsvp_x1);
train_y = cat(1, train_y, train_rsvp_y0, train_rsvp_y1);

%% random permutation
permLen = randperm(length(train_y));
train_x = train_x(:, :, permLen);
train_y = train_y(permLen);

train_y(train_y == 4) = 0;  % non-target
train_y(train_y == 5) = 1;  % target
train_y(train_y == 6) = 2;  % right perturbation
train_y(train_y == 7) = 3;  % left perturbation

test_y(test_y == 4) = 0;  % non-target
test_y(test_y == 5) = 1;  % target
test_y(test_y == 6) = 2;  % right perturbation
test_y(test_y == 7) = 3;  % left perturbation
