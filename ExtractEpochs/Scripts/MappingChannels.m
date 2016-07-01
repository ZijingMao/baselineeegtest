%% transfer 256 channel to 64 channel
load('chanlocs.mat')

[ selectedIdx, selectedDist ] = channel_converter( chanlocs256, chanlocs64 );
