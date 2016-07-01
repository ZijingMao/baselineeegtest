load('data.mat');

totalSubs = length(labels);

parfor subID = 1:totalSubs
    disp(['subID: ' num2str(subID)]);
    [ x{subID} ] = getXDAWNFeature( inputs{subID} );     
end
y = labels;

save('xDAWNFeature.mat', 'x', 'y');
