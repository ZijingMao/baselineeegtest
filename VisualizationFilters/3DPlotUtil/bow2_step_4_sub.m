function [O_training, O_testing] = bow2_step_4_sub(I_training, I_testing, matrix1, matrix2, conf_struct, classid)



%--------  PRE-ALLOCATE RESULTS (DISCRIMINAN TRAINING/TESTING)   ----------
[chan, freq, nsamples] = size(I_training);
O_training = zeros(conf_struct.rank_n, nsamples);
[~,~,nsamples] = size(I_testing);
O_testing = zeros(conf_struct.rank_n, nsamples);

N = 0;   % The Counter for the discriminant features

% Extract locations in both matrices, selecting locations of the higher
% values
while ( N <= conf_struct.rank_n)
    
    % Search Maximum values
    curr_max1 = max(max(matrix1));  % matrix 1
    curr_max2 = max(max(matrix2));  % matrix 2
    
    
    %****** T-VALUES MATRIX 1 ********
    % Get the locations of the maximum value on matrix 1
    tmp = matrix1 == curr_max1;
        
    % Get the chan/freq location of the first element with the max value
    [chan1, freq1] = ind2sub([chan, freq],find(tmp));
    
    
    %****** T-VALUES MATRIX 2 ********
    % Get the locations of the maximum value on matrix 2
    tmp = matrix2 == curr_max2;
        
    % Get the chan/freq location of the first element with the max value
    [chan2, freq2] = ind2sub([chan, freq],find(tmp));
    
    
    % Could happen the case where these locatons are the same, to avoid copying
    % the same data, detect this situation and extract one or two arrays
    % depending if the locations are or not equal
    
    if ( (chan1(1) == chan2(1)) && (freq1(1) == freq2(1)) )
        
        % Locations are equal, just one recording, save values and extract
        % data
        
        N = N+1;
        
        if ( N <= conf_struct.rank_n)
            conf_struct.discriminant_features_location(N, 1, conf_struct.crossv_iteration, classid) = chan1;
            conf_struct.discriminant_features_location(N, 2, conf_struct.crossv_iteration, classid) = freq1;
        
            O_training(N,:) = I_training(chan1, freq1, :);
            O_testing(N,:)  = I_testing(chan1, freq1, :);
        end
        
        
        
    else
        
        % Locations are different, data from both location will be
        % extracted
        
        % From first matrix
        N = N+1;
        
        if ( N <= conf_struct.rank_n)
            conf_struct.discriminant_features_location(N, 1, conf_struct.crossv_iteration, classid) = chan1;
            conf_struct.discriminant_features_location(N, 2, conf_struct.crossv_iteration, classid) = freq1;
        
            O_training(N,:) = I_training(chan1, freq1, :);
            O_testing(N,:)  = I_testing(chan1, freq1, :);
        end
        
        % From second matrix
        N = N+1;
        
        if ( N <= conf_struct.rank_n)
            conf_struct.discriminant_features_location(N, 1, conf_struct.crossv_iteration, classid) = chan2;
            conf_struct.discriminant_features_location(N, 2, conf_struct.crossv_iteration, classid) = freq2;
        
            O_training(N,:) = I_training(chan2, freq2, :);
            O_testing(N,:)  = I_testing(chan2, freq2, :);
        end
        
    end
    
    % Delete maximum values from matrices so the second ones will be next
    tmp = matrix1 == curr_max1;
    matrix1(tmp) = 0;
    
    tmp = matrix2 == curr_max2;
    matrix2(tmp) = 0;
    
    
end
end