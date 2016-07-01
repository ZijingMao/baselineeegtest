cd '/home/zijing.mao/eeglab13_4_4b';
eeglab;
cd '/home/zijing.mao/X2_RSVP_Expertise';
addpath(genpath(pwd));

close all;

%% preprocess
isResample = false;
isReChans = true;
isFilter = false;
isEpoch = false;

for idx = 1:1
    extract_epochs(idx, isResample, isReChans, isFilter, isEpoch);
end
    
%% generate epochs
subSize = 43;
Inputs = cell(1, subSize);
Labels = cell(1, subSize);
SubIDs = cell(1, subSize);
parfor idx = 1:subSize
    [Inputs{idx}, Labels{idx}, SubIDs{idx}] = generate_epochs(idx);
end

% save('X2RSVP.mat', 'Inputs', 'Labels', '-v7.3');

%% get date and time
subIDs = zeros(length(SubIDs), 1);
for i = 1:length(SubIDs)
    subIDs(i) = str2double(SubIDs{i});
end
subIDs = subIDs - 3200;

%% separate data by subject
a = cell(10, 1);
b = cell(10, 1);
for i = 1:10
    idx = find(subIDs==i);
    for j = 1:length(idx)
        a{i} = cat(3, a{i}, Inputs{idx(j)});
        b{i} = cat(1, b{i}, Labels{idx(j)});
    end
end
Inputs = a;
Labels = b;

for i = 1:10
    permute(Inputs{i}, [3, 1, 2]);
end
for i = 1:10
    Inputs{i} = permute(Inputs{i}, [3, 1, 2]);
end
for i = 1:10
    InputLen = size(Inputs{i}, 1);
    Inputs{i} = reshape(Inputs{i}, [InputLen, 1, 64, 128]);
end

for i = 1:10
    Inputs{i} = permute(Inputs{i}, [4, 3, 2, 1]);
    Labels{i} = permute(Labels{i}, [2, 1]);
end

for i = 1:10
    Labels{i} = Labels{i}-1;
end

%% feature
idx = 1;
a = squeeze(Inputs{idx}(:, :, :, Labels{idx} == 1));
b = squeeze(Inputs{idx}(:, :, :, Labels{idx} == 2));
aa = mean(a, 3);
bb = mean(b, 3);
subplot(2, 1, 1)
plot(aa)
title('nontarget');
axis([1 128 -10 10]);
subplot(2, 1, 2)
plot(bb)
title('target');
axis([1 128 -10 10]);
savefig(gcf, [num2str(idx) '.fig']);

%% after normalization
for idx = 1:10

    inputs = squeeze(Inputs{idx});
    inputs = permute(inputs, [3, 1, 2]);

    n = find(Labels{idx} == 0);
    t = find(Labels{idx} == 1);
    data = inputs([n(1:200);t(1:200)], :, :);

    [~, mu, sigma] = zscore(data);
    inputs = normalize(inputs, mu, sigma);

%     data = inputs([n(1:200);t(1:200)], :, :);
%     maxVal = squeeze(max(max(max(data))));
%     minVal = squeeze(min(min(min(data))));
%     range = maxVal - minVal;
%     inputs = (inputs - minVal)/range;
    
    Inputs{idx} = permute(inputs, [2, 3, 4, 1]);
    
%     a = squeeze(inputs(Labels{idx} == 0, :, :));
%     b = squeeze(inputs(Labels{idx} == 1, :, :));
%     aa = mean(a, 3);
%     bb = mean(b, 3);
%     subplot(2, 1, 1)
%     plot(aa)
%     title('nontarget');
%     axis([1 128 -2 2]);
%     subplot(2, 1, 2)
%     plot(bb)
%     title('target');
%     axis([1 128 -2 2]);
%     saveas(gcf, [num2str(idx) 'calibrate'], 'png');
%     close gcf;
end

save('X2RSVP.mat', 'Inputs', 'Labels', '-v7.3');