function [ subPowerData ] = get_feature_data( subData )

subData = permute(subData, [3, 1, 2]);

[epochNum, chanNum, ~] = size(subData);
% 20 is the feature dimension
subPowerData = zeros([epochNum, chanNum, 20]);
for epoch = 1:epochNum
    disp(['epoch: ' num2str(epoch)]);
    for chan = 1:chanNum
        disp(['chan: ' num2str(chan)]);
        subPowerData(epoch, chan, :) = ...
            SVM_featur_extract( squeeze(subData(epoch, chan, :)));
    end
end

end

