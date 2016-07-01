%%
% load('X2RSVP64CHAN.mat')

%%
for subIdx = 1:10
    
    %%
    train_x = x{subIdx};
    train_y = y{subIdx};
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
    elseif total_epoch-6000 > 1000
        train_epoch = 6000;
    else
        train_epoch = 5000;
    end
    test_x = train_x(:, :, train_epoch+1:end);
    test_y = train_y(train_epoch+1:end);
    train_x = train_x(:, :, 1:train_epoch);
    train_y = train_y(1:train_epoch);
    
    %%
    train_x = squeeze(train_x);
    test_x = squeeze(test_x);
    train_x = reshape(train_x, [64*64, size(train_x, 3)])';
    test_x = reshape(test_x, [64*64, size(test_x, 3)])';
    
    %%
    train_x = reshape(train_x, [length(train_y), 64, 64]);
    test_x = reshape(test_x, [length(test_y), 64, 64]);
    
    % %%
    % train_x = reshape(train_x, [length(train_y), 64*64]);
    % test_x = reshape(test_x, [length(test_y), 64*64]);
    
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
    
    savefig(gcf, [num2str(subIdx) '.fig']);
    
    pause(2);
    close all;
    
end