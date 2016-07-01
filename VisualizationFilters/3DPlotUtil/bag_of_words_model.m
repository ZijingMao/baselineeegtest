function [error_rate, prob_ratios] = bag_of_words_model(CtrA, CteA, CtrB, CteB, param)
% Simple Implementation of the Bag-of-Words model for classify EEG data
% Mauricio Merino, Jia Meng => UTSA, 2011


% --------------   SPLIT CLUSTERING DATA INTO EPOCHS   -------------------
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
sec_A_test_sample_prob_A = CteA;
sec_A_test_sample_prob_B = CteA;
sec_B_test_sample_prob_A = CteB;
sec_B_test_sample_prob_B = CteB;
     

% ------- CALCUALTE WORDS PROBABILTY FOR TRAINING AND TESTING DATA --------
% Calculate words probability on the A and B training epochs
for j=1:param.current_words_number
        
    % Calculate training words probability
    words_prob_sec_A(j) =  sum(sum(CtrA == j))/(param.crossv_num_trai_epochs*param.epochs_per_section);
    words_prob_sec_B(j) =  sum(sum(CtrB == j))/(param.crossv_num_trai_epochs*param.epochs_per_section);
           
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

% --------- MAKE PREDICTION BASED ON PROBABILITES, COUNT ERRORS ----------
% Perform the evaluation for every testing epochs to belong to A or B
% and count erros
temp = 0;       % For count classify errors on testing A data
temp1 = 0;      % For count classify errors on testing B data
prob_ratios = zeros(2,param.crossv_num_test_epochs);  % A & B testing ratios
    
for j=1:param.crossv_num_test_epochs % A and B testing epochs simultaneosly
    
    % testing epoch j from section A data
    P1 = log(sec_A_test_sample_prob_A(j,:));
    P2 = log(sec_A_test_sample_prob_B(j,:));
    prob_ratios(1,j) = sum(P1)/sum(P2);     % Save the ratio
    if ( sum(P1) < sum(P2))
        temp = temp + 1;
    end
    
    % testing epoch j from section B data
    P1 = log(sec_B_test_sample_prob_B(j,:));
    P2 = log(sec_B_test_sample_prob_A(j,:));
    prob_ratios(2,j) = sum(P1)/sum(P2);     % Save the ratio
    if ( sum(P1) < sum(P2))
       temp1 = temp1 + 1;
    end        
end

% Finally, calcualte the total error rate
error_rate = (temp + temp1)/(2*param.crossv_num_test_epochs); 
        
end

