function [ave_error_rate, crossv_error] = bag_of_words(clusterA, clusterB, words, section_size, crossv_rank, epoch_size)
% Simple Implementation of the Bag-of-Words model for classify data
% returns the total avergae of the specified number of error rates, after
% calculate the probabilites using cross validation.
% Mauricio Merino, Jia Meng => UTSA, 2011

% Clusters A & b are splitted in training (size/epoch_size) and testing
% data (90% of size/epoch_size), each part is splitted again in rows
% accroding tho the epoch size

crossv_test_size = floor(section_size/crossv_rank);  % size of the testing data
crossv_num_test_epochs = floor(crossv_test_size/epoch_size); % # testing epochs with the specified epoch size
crossv_num_trai_epochs = floor( (crossv_test_size*(crossv_rank - 1))/ epoch_size);

% Dictionary words probability on training A & B sections
words_prob_sec_A = zeros(1,words);
words_prob_sec_B = zeros(1,words);

% The record for cross validation error ratew
crossv_error = zeros(1,crossv_rank);

% Define the first starting point for testing data
for i=1:crossv_rank  % Use cross validation, number of states

    % Extract training and testing data from clusters
    % Limits for testing data on clusters
    temp  = floor( crossv_test_size * (i-1)) + 1;
    temp1 = floor( crossv_test_size * i);
    
    testing_epochs_A = clusterA(temp:temp1);            % Testing A
    testing_epochs_A = testing_epochs_A(1:(crossv_num_test_epochs*epoch_size));
    testing_epochs_A = reshape(testing_epochs_A, [epoch_size, crossv_num_test_epochs] )';
       
    testing_epochs_B = clusterB(temp:temp1);            % Testing B
    testing_epochs_B = testing_epochs_B(1:(crossv_num_test_epochs*epoch_size));
    testing_epochs_B = reshape(testing_epochs_B, [epoch_size,crossv_num_test_epochs] )';
     
    training_epochs_A = clusterA;                       % Training A
    training_epochs_A(temp:temp1) = [];
    training_epochs_A = training_epochs_A(1:(crossv_num_trai_epochs*epoch_size));
    training_epochs_A = reshape(training_epochs_A, [epoch_size, crossv_num_trai_epochs] )';
       
    training_epochs_B = clusterB;                       % Training B
    training_epochs_B(temp:temp1) = [];
    training_epochs_B = training_epochs_B(1:(crossv_num_trai_epochs*epoch_size));
    training_epochs_B = reshape(training_epochs_B, [epoch_size,crossv_num_trai_epochs])';
      
    % Words Probabilty in  testing epochs with the values from training A & B
    sec_A_test_sample_prob_A = testing_epochs_A;
    sec_A_test_sample_prob_B = testing_epochs_A;
    sec_B_test_sample_prob_A = testing_epochs_B;
    sec_B_test_sample_prob_B = testing_epochs_B;
    
    
    % Calculate words probability on the A and B training epochs
    for j=1:words
        
        % Calculate training words probability
        words_prob_sec_A(j) =  sum(sum(training_epochs_A == j))/(crossv_num_trai_epochs*epoch_size);
        words_prob_sec_B(j) =  sum(sum(training_epochs_B == j))/(crossv_num_trai_epochs*epoch_size);
        
        % Calculate words probability for every testing epoch (A & B) based
        % on training results.
        
        % testing epochs from section A
        temp3 = sec_A_test_sample_prob_A == j;
        sec_A_test_sample_prob_A(temp3) = words_prob_sec_A(j);
        temp3 = sec_A_test_sample_prob_B == j;
        sec_A_test_sample_prob_B(temp3) = words_prob_sec_B(j);
        
        % testing epochs from section B
        temp3 = sec_B_test_sample_prob_A == j;
        sec_B_test_sample_prob_A(temp3) = words_prob_sec_A(j);
        temp3 = sec_B_test_sample_prob_B == j;
        sec_B_test_sample_prob_B(temp3) = words_prob_sec_B(j);
    end
    
    
    % Perform the evaluation for every testing epochs to belong to A or B
    % and count erros
    temp = 0;       % For count classify errors on testing A data
    temp1 = 0;      % For count classify errors on testing B data
    
    for j=1:crossv_num_test_epochs % A and B testing epochs simultaneosly
        % testing epoch j from section A data
        P1 = log(sec_A_test_sample_prob_A(j,:));
        P2 = log(sec_A_test_sample_prob_B(j,:));
        if ( sum(P1) < sum(P2))
            temp = temp + 1;
        end
        % testing epoch j from section B data
        P1 = log(sec_B_test_sample_prob_B(j,:));
        P2 = log(sec_B_test_sample_prob_A(j,:));
        if ( sum(P1) < sum(P2))
            temp1 = temp1 + 1;
        end        
    end
    
    % Finally, calcualte the total error rate
    crossv_error(i) = (temp + temp1)/(2*crossv_num_test_epochs); 
    
end % End of the cross validation

% Average of error rate after cross validation
ave_error_rate = sum(crossv_error)/crossv_rank;
    
end

