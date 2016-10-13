function [ data_ar ] = get_ar_feature( data )
%GET_AR_FEATURE Summary of this function goes here
%   the input size should be channel by time by epoch

[channel, ~, epoch] = size(data);

% fprintf(1, '\r\r\r\n');
data_ar = zeros(epoch, channel);
for idx = 1:epoch    
    [each_epoch_coeff] = get_ar_feature_one_epoch(data, epoch);
    data_ar(idx,:) = each_epoch_coeff;
    %if mod(idx, 10) == 0
    % fprintf(1, '\b\b\b\b%s', num2str(floor(idx/epoch*10000), '%04i'));
    %end
end

end

