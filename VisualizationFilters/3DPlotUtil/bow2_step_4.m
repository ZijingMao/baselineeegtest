function [training_A, testing_A, training_B, testing_B, training_C, testing_C,  conf_struct] = ...
    bow2_step_4(features_trA, features_teA, features_trB, features_teB,...
    features_trC, features_teC, conf_struct)

% This function receives the [Channel - Frequency - Time] training and
% testing data for the A and B sections and perform Two sample T- test to
% find discriminat features between trainig data samples; then rank the top
% n (defined by user) discriminant feaures and extract the time points for
% the discriminat time - frequency pairs. Same combinations are used for 
% extract the time points for the testing data. UTSA, 2011.

% VERSION 2 FOR 3 CLASSES/2012


% Save number of channels and freq. components to the struct (same for all)
[chan, freq, ~] = size(features_trA);
conf_struct.nchannels = chan;
conf_struct.nfeq = freq;


%-------- PERFORM T-TEST FOR THE 3 COMBINATIONS (1,2; 1,3; 2,3)------------
% Two sample T-test for training data ** MODIFY THIS FOR NEXT VERSION****
ttest_res = zeros(chan,freq,3);  % Z=3 because 3 classes
for i=1:chan
    for j=1:freq
        
        
        %/////////////////  CLASS 1 WITH CLASS 2 T-TEST   /////////////////
        [~,~,~,stats] = ttest2(features_trA(i,j,:), features_trB(i,j,:));
        ttest_res(i,j,1) = abs(stats.tstat); % T-value bigger value, more different
        
        %/////////////////  CLASS 1 WITH CLASS 3 T-TEST   /////////////////
        [~,~,~,stats] = ttest2(features_trA(i,j,:), features_trC(i,j,:));
        ttest_res(i,j,2) = abs(stats.tstat); % T-value bigger value, more different
        
        %/////////////////  CLASS 2 WITH CLASS 3 T-TEST   /////////////////
        [~,~,~,stats] = ttest2(features_trB(i,j,:), features_trC(i,j,:));
        ttest_res(i,j,3) = abs(stats.tstat); % T-value bigger value, more different
        
        
    end
end


%-------  FIND THE CHAN/FREQ LOCATION OF THE DSCRIMINANT FEATURES  --------
% The Top N discrminant features should be extracted from the two t-test
% results matrices every class have. **** Modify accordingly this part for
% the automatic version later***


%////////////// CLASS 1 RESULTS   \\\\\\\\\\\\\\\\\
[training_A, testing_A] = bow2_step_4_sub...
    (features_trA, features_teA, ttest_res(:,:,1), ttest_res(:,:,2), conf_struct, 1);


%////////////// CLASS 2 RESULTS   \\\\\\\\\\\\\\\\\
[training_B, testing_B] = bow2_step_4_sub...
    (features_trB, features_teB, ttest_res(:,:,1), ttest_res(:,:,3), conf_struct, 2);


%////////////// CLASS 3 RESULTS   \\\\\\\\\\\\\\\\\
[training_C, testing_C] = bow2_step_4_sub...
    (features_trC, features_teC, ttest_res(:,:,2), ttest_res(:,:,3), conf_struct, 3);

end


