%%
% load('X2RSVP64CHAN.mat')

%%
x_new = [];
y_new = [];
for subIdx = 1:10
    train_x = x{subIdx};
    train_y = y{subIdx};
    train_y(train_y == 4) = 0;
    train_y(train_y == 5) = 1;
    
    x_new = cat(3, x_new, train_x);
    y_new = cat(1, y_new, train_y);
end
train_epoch = 100000;
test_x = x_new(:, :, train_epoch+1:end);
test_y = y_new(train_epoch+1:end);
train_x = x_new(:, :, 1:train_epoch);
train_y = y_new(1:train_epoch);

%%
train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

%%
train_x = reshape(train_x, [length(train_y), 64, 64]);
test_x = reshape(test_x, [length(test_y), 64, 64]);

%%
a = train_x(train_y==0, :, :);
a = mean(a, 1);
a = squeeze(a);
subplot(2, 2, 1);
colormap(jet);imagesc(a)
title('Un-norm non-target erp');
a = train_x(train_y==1, :, :);
a = mean(a, 1);
a = squeeze(a);
subplot(2, 2, 2);
colormap(jet);imagesc(a)
title('Un-norm target erp');

%%
train_x = reshape(train_x, [length(train_y), 64*64]);
test_x = reshape(test_x, [length(test_y), 64*64]);

%% normalize (optimal)
[~, mu, sigma] = zscore(train_x);
train_x = normalize(train_x, mu, sigma);
test_x = normalize(test_x, mu, sigma);

%%
train_x = reshape(train_x, [length(train_y), 64, 64]);
test_x = reshape(test_x, [length(test_y), 64, 64]);

%%
a = train_x(train_y==0, :, :);
a = mean(a, 1);
a = squeeze(a);
subplot(2, 2, 3);
colormap(jet);imagesc(a)
title('Norm non-target erp');
a = train_x(train_y==1, :, :);
a = mean(a, 1);
a = squeeze(a);
subplot(2, 2, 4);
colormap(jet);imagesc(a)
title('Norm target erp');

savefig(gcf, 'all.fig');
close all;


%%
train_x = reshape(train_x, [length(train_y), 64, 64]);
test_x = reshape(test_x, [length(test_y), 64, 64]);
a = train_x(train_y==1, :, :);
a = squeeze(mean(a, 1));
colormap(jet);imagesc(a')