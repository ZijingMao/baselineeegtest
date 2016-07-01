function [start_point, end_point] = ...
    process_single_data_p300( subIdx, type )

start_point = 0;
end_point = 1;
pnt = 64;
train_x = [];
test_x = [];
train_y = [];
test_y = [];

if type == 0    % the type is raw data
    start_time = 0.200;
    end_time = 0.400;
    start_point = floor(pnt*start_time);
    end_point = ceil(pnt*end_time);
    load(['RSVP_X2_S' num2str(subIdx, '%02i') '_RAW_CH64.mat']);
elseif type == 1    % the type is frequency data
    start_freq = 5;
    end_freq = 6;
    start_point = floor(pnt*start_freq/32);
    end_point = ceil(pnt*end_freq/32);
    load(['RSVP_X2_S' num2str(subIdx, '%02i') '_FREQ_CH64.mat']);
elseif type == 1.5  % the type is frequency data
    start_freq = 2;
    end_freq = 10;
    start_point = floor(pnt*start_freq/32);
    end_point = ceil(pnt*end_freq/32);
    load(['RSVP_X2_S' num2str(subIdx, '%02i') '_FREQ_CH64.mat']);
end

train_x = train_x(:, start_point:end_point, :, :);
test_x = test_x(:, start_point:end_point, :, :);

save(['RSVP_X2_S' num2str(subIdx, '%02i') '_P300' num2str(type) '_CH64.mat'],...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');

end