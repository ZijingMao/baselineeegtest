function [ configs ] = config_epoch_extract( configs )

chanlocs64 = [];
chanlocs256 = [];
montageIdx256to64 = [];
channelIdx64to30 = [];

load('chanlocs_bk.mat');
configs.chanlocs64 = chanlocs64;
configs.chanlocs256 = chanlocs256;
configs.chanlocs256to64 = montageIdx256to64;
configs.chanlocs64to30 = channelIdx64to30;

configs.DATESTRING = datestr(now, 'mm.dd.yyyy.HH.MM.SS');   % get the unique id for storing data



end

