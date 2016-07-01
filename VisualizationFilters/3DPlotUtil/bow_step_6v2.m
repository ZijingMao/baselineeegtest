function [error_rate, param] = bow_step_6v2(CtrA, testing_A, CtrB, testing_B, param)
% Simple Implementation of the Bag-of-Words model for classify EEG data
% CtrA/B = Cluster Training A & B


% ----------   CLUSTER THE TESTING DATA USING WORD CENTROIDS  -------------
% Pre-allocate variables
words_distances = zeros(1,param.current_words_number);
[~, nsamples] = size(testing_A);
CteA = zeros(1, nsamples);
CteB = zeros(1, nsamples);
ctrs = param.current_centroids;
nwords = param.current_words_number;

% Data loop, going through time samples
for i=1:nsamples
    
    %----------------    TESTING A DATA   ------------------
    % Extract current point
    var1 = testing_A(:,i);
    
    % Words loop, to compare distances
    for id = 1:nwords
        
        temp_var = (var1' - ctrs(id,:));
        words_distances(id) = sqrt(sum(temp_var.^2));
    end
    
    % Select the lowest distance and asociate the current point to that
    % cluster
    CteA(i) = sum((1:nwords).*(words_distances == min(words_distances)));
    
    
    %----------------    TESTING B DATA   ------------------
    % Extract current point
    var1 = testing_B(:,i);
    
    % Words loop, to compare distances
    for id = 1:nwords 
        
        temp_var = (var1' - ctrs(id,:));
        words_distances(id) = sqrt(sum(temp_var.^2));
    end
    
    % Select the lowest distance and asociate the current point to that
    % cluster
    CteB(i) = sum((1:nwords).*(words_distances == min(words_distances)));
    
end


% ------- IF THIS IS THE SELECTED OBSERVATION, COMPLETE DICTIONARY  -------

if param.crossv_iteration == param.observation
        
    % Preallocate vectors for complete dictinaries (both sections)
    complete_dict_A = zeros(1,param.section_size);
    complete_dict_B = zeros(1,param.section_size);
        
    % Add the testing dictionary to the vector
    complete_dict_A(param.test_start:param.test_end) = CteA;
    complete_dict_B(param.test_start:param.test_end) = CteB;
       
    % Include the training data dictionary (begining portion if any)
    if (param.test_start > 1)
        complete_dict_A(1:param.test_start-1) = CtrA(1:param.test_start-1);
    
        complete_dict_B(1:param.test_start-1) = CtrB(1:param.test_start-1);
    end
       
    % Include the training data dictionary (ending portion if any)
    if ((param.section_size - param.test_end) > 1)
        complete_dict_A(param.test_end+1:end) = CtrA(param.test_start:end);
        
        complete_dict_B(param.test_end+1:end) = CtrB(param.test_start:end);
    end
    
    % Replace the saved dictionary (just training data) with the complete
    param.dictionary = [complete_dict_A, complete_dict_B];
    
end
         


% --------------   SPLIT CLUSTERING DATA INTO EPOCHS   -------------------
% Reshape N x 1 words array into a M x n training and testing
% epochs matrices.
% CteA/B = Cluster Testing A & B .:. CtrA/B = Cluster Training A & B

% Testing A cluster data
CteA = CteA(1:(param.crossv_num_test_epochs*param.epochs_per_section));
CteA = reshape(CteA, [param.epochs_per_section, param.crossv_num_test_epochs] )';

% Testing B cluster data
CteB = CteB(1:(param.crossv_num_test_epochs*param.epochs_per_section));
CteB = reshape(CteB, [param.epochs_per_section, param.crossv_num_test_epochs] )';

% Training A cluster data
CtrA = CtrA(1:(param.crossv_num_trai_epochs*param.epochs_per_section));
CtrA = reshape(CtrA, [param.epochs_per_section, param.crossv_num_trai_epochs] )';

% Training B cluster data
CtrB = CtrB(1:(param.crossv_num_trai_epochs*param.epochs_per_section));
CtrB = reshape(CtrB, [param.epochs_per_section, param.crossv_num_trai_epochs] )';
 
 
% ------------   PREALLOCATE WORDS PROBABILTY VARIABLES  ------------------
% Dictionary words probability on training A & B sections
words_prob_sec_A = zeros(1,param.current_words_number);
words_prob_sec_B = zeros(1,param.current_words_number);

% Words Probabilty in  testing epochs with the values from training A & B
% Make two copies of testing epochs, one will be associated with training A
% epochs and the other with training B epochs
sec_A_test_sample_prob_A = CteA;
sec_A_test_sample_prob_B = CteA;
sec_B_test_sample_prob_A = CteB;
sec_B_test_sample_prob_B = CteB;
     

% ------- CALCUALTE WORDS PROBABILTY FOR TRAINING AND TESTING DATA --------
% Calculate words probability on the A and B training epochs
for j=1:param.current_words_number
        
    % Calculate training words probability, Training A section
    Pa = sum(sum(CtrA == j));
    if (Pa > 0)                  % The word does exists on the section
        words_prob_sec_A(j) =  Pa /(param.crossv_num_trai_epochs*param.epochs_per_section);
    else
        words_prob_sec_A(j) = 1; % The word doesn not exist on the section
    end
    
    % Calculate training words probability, Training B section
    Pb = sum(sum(CtrB == j));
    if (Pb > 0)                  % The word does exists on the section
        words_prob_sec_B(j) =  Pb /(param.crossv_num_trai_epochs*param.epochs_per_section);
    else
        words_prob_sec_B(j) = 1; % The word doesn not exist on the section
    end
             
    % Calculate words probability for every testing epoch based on training results.
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


% Calculate and save discriminant powers for each word (Pa / Pb )
param.words_disc_powers = log(words_prob_sec_A./words_prob_sec_B);


% --------- MAKE PREDICTION BASED ON PROBABILITES, COUNT ERRORS ----------
% Evaluate every testing epochs to belong to A or B and count erros
temp = 0;       % For count classify errors on testing A data
temp1 = 0;      % For count classify errors on testing B data

% Get the row number (postion) from all the testing epochs in cross-validation
% to start saving probability values for this cross-validation iteration
temp_pos = (param.crossv_num_test_epochs*(param.crossv_iteration - 1));

for j=1:param.crossv_num_test_epochs % A and B testing epochs simultaneosly
    
    % TESTING EPOCH J POR TESTING A DATA
    % Log of the values
    P1 = log(sec_A_test_sample_prob_A(j,:));
    P2 = log(sec_A_test_sample_prob_B(j,:));
    
    % Save probabilities
    param.test_epoch_prob_values(temp_pos + j,1) = sum(P1);
    param.test_epoch_prob_values(temp_pos + j,2) = sum(P2);
    
    % Make decision    
    if ( sum(P1) < sum(P2))
        temp = temp + 1;
    elseif (sum(P1) == sum(P2))
        
        % Randomly select a class (count error)
        tmp_var = rand;
        if (tmp_var >= 0.5)
            temp = temp + 1;
        end
    end
    
    % TESTING EPOCH J POR TESTING B DATA
    % Log of the values
    P1 = log(sec_B_test_sample_prob_B(j,:));
    P2 = log(sec_B_test_sample_prob_A(j,:));
    
    % Save probabilities
    param.test_epoch_prob_values(temp_pos + j,3) = sum(P1);
    param.test_epoch_prob_values(temp_pos + j,4) = sum(P2);
    
    % Make decision
    if ( sum(P1) < sum(P2))
       temp1 = temp1 + 1;
    elseif (sum(P1) == sum(P2))
        
        % Randomly select a class (count error)
        tmp_var = rand;
        if (tmp_var >= 0.5)
            temp1 = temp1 + 1;
        end
    end   
    
end

% Finally, calcualte the total error rate
error_rate = (temp + temp1)/(2*param.crossv_num_test_epochs); 
        
end

