load('/home/zijing.mao/BaselineAnalysis/Source/chanlocs.mat');

for idx = 1:size(c1, 1)
    
    visSpatialFilter( c1(idx,:,:), idx, chanlocs64 );
    
end