load('/home/zijing.mao/Static Motion RSVP/CT2WSExperiment/Data/CTRAW.mat');
parfor subID = 1:15
    disp(['subID: ' num2str(subID)]);
    [ featDataA{subID} ] = get_feature_data( dataClassA{subID} );    
    [ featDataB{subID} ] = get_feature_data( dataClassB{subID} );     
end
save('/home/zijing.mao/Static Motion RSVP/CT2WSExperiment/Data/featData.mat', ...
                'featDataA', 'featDataB');
