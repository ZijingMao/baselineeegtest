

%% start get subject information
expStub = 'I:/level2_256Hz_epoch/';
expDatasetFile = [expStub datasetName '/'];
if ~exist(expDatasetFile, 'dir')
    error('no such experiment');
end

x = [];
y = [];
for expIdx = 1:length(expStr)
    load([expStub expStr{expIdx} '.mat'], 'subIDs');

    subUIDXs = unique(subIDs);
    subSize = length(subUIDXs);
    x_tmp = cell(1, subSize); 
    y_tmp = cell(1, subSize);
    for i = 1:subSize
        disp(['Get Current Subject: ' num2str(i)]);
        idx = find(subIDs==subUIDXs(i));
        for j = 1:length(idx)
            load([expStub datasetName '/' expStr{expIdx} num2str(idx(j)) '.mat']);
            if ~isempty(data)
                data = preprocess_data(data, samplingRate, channelSize, timeRange);
                x_tmp{i} = cat(3, x_tmp{i}, data);
                y_tmp{i} = cat(1, y_tmp{i}, label);
            end

            if singleFlag
                x_tmp{i} = single(x_tmp{i});
                y_tmp{i} = single(y_tmp{i});
            end
        end
    end
    x = [x x_tmp];
    y = [y y_tmp];
end

save([expStub 'DataSets/' newDatasetName '.mat'], 'x', 'y', '-v7.3');

