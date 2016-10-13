function [each_epoch_coeff] = get_ar_feature_one_epoch(data, epoch)

each_data = data(:, :, epoch);
each_epoch_coeff = [];
for idx1 = 1:size(each_data, 1)
    each_channel = squeeze(each_data(idx1,:));
    each_mb = ar(each_channel, 6, 'burg');  % 6 order
    each_coeff = each_mb.A(2:end);
    each_epoch_coeff = [each_epoch_coeff, each_coeff];
end

end