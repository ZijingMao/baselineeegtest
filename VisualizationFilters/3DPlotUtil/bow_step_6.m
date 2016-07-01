function [error_rate, param] = bow_step_6(CtrA, CteA, CtrB, CteB, param)
% Simple Implementation of the Bag-of-Words model for classify EEG data

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
equal_prob = 0; % For count the "equal probability" on Testing data
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
        equal_prob = equal_prob + 1;
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
        equal_prob = equal_prob + 1;
    end   
    
end

% Finally, calcualte the total error rate
error_rate = ( (temp + temp1) + (equal_prob/2) )/(2*param.crossv_num_test_epochs); 
        
end

