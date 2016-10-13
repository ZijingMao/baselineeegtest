%%
load('X2RSVP64CHAN.mat')

subIdx = 1;

%%
train_x = x{subIdx};
train_y = y{subIdx};
train_y(train_y == 4) = 0;
train_y(train_y == 5) = 1;

total_epoch = length(train_y);
if total_epoch-10000 > 1000
    train_epoch = 10000;
else
    train_epoch = 9000;
end
test_x = train_x(:, :, train_epoch+1:end);
test_y = train_y(train_epoch+1:end);
train_x = train_x(:, :, 1:train_epoch);
train_y = train_y(1:train_epoch);

%%
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

%% normalize (optimal)
[~, mu, sigma] = zscore(train_x);
train_x = normalize(train_x, mu, sigma);
test_x = normalize(test_x, mu, sigma);

%% 
train_x = reshape(train_x, [length(train_y), 64, 64]);
test_x = reshape(test_x, [length(test_y), 64, 64]);

%% 
train_x = reshape(train_x, [length(train_y), 64*64]);
test_x = reshape(test_x, [length(test_y), 64*64]);

%%
a = train_x(train_y==0, :, :);
a = mean(a, 1);
a = squeeze(a);
subplot(2, 1, 1);
colormap(jet);imagesc(a')
title('normalized subject 1 erp');
a = train_x(train_y==1, :, :);
a = mean(a, 1);
a = squeeze(a);
subplot(2, 1, 2);
colormap(jet);imagesc(a')
title('normalized subject 2 erp');

%%
test_x = squeeze(test_x);
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

test_y2 = pred(:, 1)>0;
test_y1 = test_y>0;

disp(num2str(sum(test_y1==test_y2)/length(test_y1)));

%%
test_y1_target = test_y1 == 0;  % 
test_y2_target = test_y2 == 0;
test_y2_nontarget = test_y2 == 1;
test_yy = (test_y1_target+test_y2_target) == 2;
test_yyy = (test_y1_target+test_y2_nontarget) == 2; % identify the wrong nontarget

test_wrong_target = test_x(test_yyy, :);
[epoch_len, ~] = size(test_wrong_target);
test_wrong_target = reshape(test_wrong_target, [epoch_len, 64, 64]);
test_wrong_target = squeeze(mean(test_wrong_target));

test_target = test_x(test_yy, :);
[epoch_len, ~] = size(test_target);
test_target = reshape(test_target, [epoch_len, 64, 64]);
test_target = squeeze(mean(test_target));

target = test_x(test_y1_target, :);
[epoch_len, ~] = size(target);
target = reshape(target, [epoch_len, 64, 64]);
target = squeeze(mean(target));

colormap('jet');
subplot(2, 3, 1);
imagesc(test_wrong_target);
title('selected wrong nontarget');
subplot(2, 3, 2);
imagesc(test_target);
title('selected nontarget');
subplot(2, 3, 3);
imagesc(target);
title('all nontarget');

%%
test_y1_target = test_y1 == 1;  % 
test_y2_target = test_y2 == 1;
test_y2_nontarget = test_y2 == 0;
test_yy = (test_y1_target+test_y2_target) == 2;
test_yyy = (test_y1_target+test_y2_nontarget) == 2; % identify the wrong nontarget

test_wrong_target = test_x(test_yyy, :);
[epoch_len, ~] = size(test_wrong_target);
test_wrong_target = reshape(test_wrong_target, [epoch_len, 64, 64]);
test_wrong_target = squeeze(mean(test_wrong_target));

test_target = test_x(test_yy, :);
[epoch_len, ~] = size(test_target);
test_target = reshape(test_target, [epoch_len, 64, 64]);
test_target = squeeze(mean(test_target));

target = test_x(test_y1_target, :);
[epoch_len, ~] = size(target);
target = reshape(target, [epoch_len, 64, 64]);
target = squeeze(mean(target));

colormap('jet');
subplot(2, 3, 4);
imagesc(test_wrong_target);
title('selected wrong target');
subplot(2, 3, 5);
imagesc(test_target);
title('selected target');
subplot(2, 3, 6);
imagesc(target);
title('all target');

%%
savefig('target vs nontarget');

%%
subplot(2, 1, 1);
a = test_target-target;
a(abs(a)<0.5) = 0 ;
colormap(jet);imagesc(a)
title('the difference of selected non-target with true non-target')

subplot(2, 1, 2);
c = test_wrong_target-target;
c(abs(c)<0.5) = 0 ;
colormap(jet);imagesc(c)
title('the difference of selected target with true non-target')

%%
c = double(c);
a = double(a);
target = double(target);
test_target = double(test_target);
test_wrong_target = double(test_wrong_target);

%%
handles.visible = false;
handles.setcaxis = true;
handles.chanlocs = chanlocs64;
handles.min_val = -10;	% change the min value for the color
handles.max_val = 10;	% change the max value for the color
handles.mycmap = set_mycmap();	% Initialize colormap matrix
load('C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration\EEGRoomPC\Zijing Mao\baselineeegtest\Source\ChannelSrc\chanlocs_bk.mat', 'chanlocs64')
handles.chanlocs = chanlocs64;
handles.saveFig = false;

%%
currTime = 60;
handles.child_fig = subplot(2, 5, 1);
generateBrainmap(currTime, a, currTime, handles);
handles.child_fig = subplot(2, 5, 2);
generateBrainmap(currTime, c, currTime, handles);
handles.child_fig = subplot(2, 5, 3);
generateBrainmap(currTime, test_wrong_target, currTime, handles);
handles.child_fig = subplot(2, 5, 4);
generateBrainmap(currTime, target, currTime, handles);
handles.child_fig = subplot(2, 5, 5);
generateBrainmap(currTime, test_target, currTime, handles);

currTime = 23;
handles.child_fig = subplot(2, 5, 6);
generateBrainmap(currTime, a, currTime, handles);
handles.child_fig = subplot(2, 5, 7);
generateBrainmap(currTime, c, currTime, handles);
handles.child_fig = subplot(2, 5, 8);
generateBrainmap(currTime, test_wrong_target, currTime, handles);
handles.child_fig = subplot(2, 5, 9);
generateBrainmap(currTime, target, currTime, handles);
handles.child_fig = subplot(2, 5, 10);
generateBrainmap(currTime, test_target, currTime, handles);

%%
target = double(target);
for idx = 1:64
    b(idx, :) = smooth(target(idx, :));
end
