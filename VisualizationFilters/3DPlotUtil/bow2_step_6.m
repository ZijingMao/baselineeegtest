function [error_rate, param] = bow2_step_6(CtrA, testing_A, CtrB, testing_B, CtrC, testing_C, param)
% Simple Implementation of the Bag-of-Words model for classify EEG data
% CtrA/B/C = Cluster Training A/B/C

% VERSION 2 FOR 3 CLASSES/2012

% ----------   CLUSTER THE TESTING DATA USING WORD CENTROIDS  -------------
words_distances = zeros(3,param.current_words_number);  % 3 because 3 classes
ctrs = param.current_centroids;
nwords = param.current_words_number;
n_classes = 3;   % MODIFY THIS LATER FOR FURTHER VERSION
sizes = zeros(1,n_classes);

% Get the number of time samples on testing data
[~,sizes(1)] = size(testing_A);
[~,sizes(2)] = size(testing_B);
[~,sizes(3)] = size(testing_C);

% pre-allocate clustered new testing data
CteA = zeros(1, sizes(1));
CteB = zeros(1, sizes(2));
CteC = zeros(1, sizes(3));

% Perform the words association based on the euclidean distance
for i=1:max(sizes)
           
    % Words loop, to calculate distances
    for id = 1:nwords
        
        % Class 1
        if i<= sizes(1)
            var1 = testing_A(:,i);   % Class 1
            temp_var = (var1' - ctrs(id,:));
            words_distances(1,id) = sqrt(sum(temp_var.^2));
        end
        
        % Class 2
        if i<= sizes(2)
            var1 = testing_B(:,i);   % Class 1
            temp_var = (var1' - ctrs(id,:));
            words_distances(2,id) = sqrt(sum(temp_var.^2));
        end
        
        % Class 3
        if i<= sizes(3)
            var1 = testing_C(:,i);   % Class 1
            temp_var = (var1' - ctrs(id,:));
            words_distances(3,id) = sqrt(sum(temp_var.^2));
        end
       
    end
    
    % Select the lowest distance and asociate the current point to that
    % cluster
    if i<= sizes(1)
        CteA(i) = sum((1:nwords).*(words_distances(1,:) == min(words_distances(1,:))));
    end
    
    if i<= sizes(2)
        CteB(i) = sum((1:nwords).*(words_distances(2,:) == min(words_distances(2,:))));
    end
    
    if i<= sizes(3)
        CteC(i) = sum((1:nwords).*(words_distances(3,:) == min(words_distances(3,:))));
    end
    
end


% ------- IF THIS IS THE SELECTED OBSERVATION, COMPLETE DICTIONARY  -------

if param.crossv_iteration == param.observation
        
    % Preallocate vectors for complete dictinaries * MAKE THIS AUTOMATIC *
    complete_dict_A = zeros(1,param.section_size(1));
    complete_dict_B = zeros(1,param.section_size(2));
    complete_dict_C = zeros(1,param.section_size(3));
        
    % Add the testing dictionary to the vector
    complete_dict_A(param.test_start(1):param.test_end(1)) = CteA;
    complete_dict_B(param.test_start(2):param.test_end(2)) = CteB;
    complete_dict_C(param.test_start(3):param.test_end(3)) = CteC;
       
    % Include the training data dictionary (begining portion if any)
    if (param.test_start(1) > 1)
        complete_dict_A(1:param.test_start(1)-1) = CtrA(1:param.test_start(1)-1);
    end
        
    if (param.test_start(2) > 1)
        complete_dict_B(1:param.test_start(2)-1) = CtrB(1:param.test_start(2)-1);
    end
        
    if (param.test_start(3) > 1)
        complete_dict_C(1:param.test_start(3)-1) = CtrC(1:param.test_start(3)-1);
    end
       
    % Include the training data dictionary (ending portion if any)
    if ((param.section_size(1) - param.test_end(1)) > 1)
        complete_dict_A(param.test_end(1)+1:end) = CtrA(param.test_start(1):end);
    end
        
    if ((param.section_size(2) - param.test_end(2)) > 1)
        complete_dict_B(param.test_end(2)+1:end) = CtrB(param.test_start(2):end);
    end
        
    if ((param.section_size(3) - param.test_end(3)) > 1)
        complete_dict_C(param.test_end(3)+1:end) = CtrC(param.test_start(3):end);
    end
    
    
    % Replace the saved dictionary (just training data) with the complete
    param.dictionary = [complete_dict_A, complete_dict_B, complete_dict_C];
    
end
         


% --------------   SPLIT CLUSTERING DATA INTO EPOCHS   -------------------
% Reshape N x 1 words array into a M x n training and testing
% epochs matrices.
% CteA/B/C = Cluster Testing A/B/C .:. CtrA/B/C = Cluster Training A/B/C

%--------------  TESTING DATA, 3 CLASSES *AUTOMATIC LATER* ---------------
% Testing A cluster data
CteA = CteA(1:(param.crossv_num_test_epochs(1)*param.epochs_per_section));
CteA = reshape(CteA, [param.epochs_per_section, param.crossv_num_test_epochs(1)] )';

% Testing B cluster data
CteB = CteB(1:(param.crossv_num_test_epochs(2)*param.epochs_per_section));
CteB = reshape(CteB, [param.epochs_per_section, param.crossv_num_test_epochs(2)] )';

% Testing C cluster data
CteC = CteC(1:(param.crossv_num_test_epochs(3)*param.epochs_per_section));
CteC = reshape(CteC, [param.epochs_per_section, param.crossv_num_test_epochs(3)] )';


%--------------  TRAINING DATA, 3 CLASSES *AUTOMATIC LATER* ---------------
% Training A cluster data
CtrA = CtrA(1:(param.crossv_num_trai_epochs(1)*param.epochs_per_section));
CtrA = reshape(CtrA, [param.epochs_per_section, param.crossv_num_trai_epochs(1)] )';

% Training B cluster data
CtrB = CtrB(1:(param.crossv_num_trai_epochs(2)*param.epochs_per_section));
CtrB = reshape(CtrB, [param.epochs_per_section, param.crossv_num_trai_epochs(2)] )';

% Training C cluster data
CtrC = CtrC(1:(param.crossv_num_trai_epochs(3)*param.epochs_per_section));
CtrC = reshape(CtrC, [param.epochs_per_section, param.crossv_num_trai_epochs(3)] )';
 
 
% ------------   PREALLOCATE WORDS PROBABILTY VARIABLES  ------------------
% Dictionary words probability on training A & B sections
words_prob_sec_A = zeros(1,param.current_words_number);
words_prob_sec_B = zeros(1,param.current_words_number);
words_prob_sec_C = zeros(1,param.current_words_number);


% THIS IS PART HAS BEEN MODIFIED FOR  3 CLASSES, MAKE AUTOMATIC LATER
% Words Probabilty in  testing epochs with the values from training A & B
% Make two copies of testing epochs, one will be associated with training A
% epochs and the other with training B epochs

% Class 1
sec_A_test_sample_prob_A = CteA;
sec_A_test_sample_prob_B = CteA;
sec_A_test_sample_prob_C = CteA;

% Class 2
sec_B_test_sample_prob_A = CteB;
sec_B_test_sample_prob_B = CteB;
sec_B_test_sample_prob_C = CteB;

% Class 3
sec_C_test_sample_prob_A = CteC;
sec_C_test_sample_prob_B = CteC;
sec_C_test_sample_prob_C = CteC;

     

% ------- CALCUALTE WORDS PROBABILTY FOR TRAINING AND TESTING DATA --------
% Calculate words probability on the A and B training epochs
for j=1:param.current_words_number
    
    % THIS IS PART HAS BEEN MODIFIED FOR  3 CLASSES, MAKE AUTOMATIC LATER
    
    % Calculate training words probability, Training A section
    Pa = sum(sum(CtrA == j));
    if (Pa > 0)                  % The word does exists on the section
        words_prob_sec_A(j) =  Pa /(param.crossv_num_trai_epochs(1)*param.epochs_per_section);
    else
        words_prob_sec_A(j) = 1; % The word doesn not exist on the section
    end
    
    % Calculate training words probability, Training B section
    Pb = sum(sum(CtrB == j));
    if (Pb > 0)                  % The word does exists on the section
        words_prob_sec_B(j) =  Pb /(param.crossv_num_trai_epochs(2)*param.epochs_per_section);
    else
        words_prob_sec_B(j) = 1; % The word doesn not exist on the section
    end
    
    % Calculate training words probability, Training C section
    Pc = sum(sum(CtrC == j));
    if (Pc > 0)                  % The word does exists on the section
        words_prob_sec_C(j) =  Pc /(param.crossv_num_trai_epochs(3)*param.epochs_per_section);
    else
        words_prob_sec_C(j) = 1; % The word doesn not exist on the section
    end
             
    
    % THIS IS PART HAS BEEN MODIFIED FOR  3 CLASSES, MAKE AUTOMATIC LATER
    % Calculate words probability for every testing epoch based on training results.
    
    % testing epochs from section A
    temp3 = CteA == j;
    sec_A_test_sample_prob_A(temp3) = words_prob_sec_A(j);
    sec_A_test_sample_prob_B(temp3) = words_prob_sec_B(j);
    sec_A_test_sample_prob_C(temp3) = words_prob_sec_C(j);
    
    % testing epochs from section B
    temp3 = CteB == j;
    sec_B_test_sample_prob_A(temp3) = words_prob_sec_A(j);
    sec_B_test_sample_prob_B(temp3) = words_prob_sec_B(j);
    sec_B_test_sample_prob_C(temp3) = words_prob_sec_C(j);
    
    % testing epochs from section C
    temp3 = CteC == j;
    sec_C_test_sample_prob_A(temp3) = words_prob_sec_A(j);
    sec_C_test_sample_prob_B(temp3) = words_prob_sec_B(j);
    sec_C_test_sample_prob_C(temp3) = words_prob_sec_C(j);
        
    
end

% THIS IS PART HAS BEEN MODIFIED FOR  3 CLASSES, MAKE AUTOMATIC LATER
% Calculate the words relevancy for this case (3 classes) class 1 is the
% background and goes as denominator, relevancy will be computed for classes 2 and 3 only.
param.words_disc_powers = zeros(2, param.current_words_number);
param.words_disc_powers(1,:) = log(words_prob_sec_B./words_prob_sec_A);
param.words_disc_powers(2,:) = log(words_prob_sec_C./words_prob_sec_A);

% THIS IS PART HAS BEEN MODIFIED FOR  3 CLASSES, MAKE AUTOMATIC LATER
% --------- MAKE PREDICTION BASED ON PROBABILITES, COUNT ERRORS ----------
% Evaluate every testing epochs to belong to A or B and count erros
class_1_error = 0;       % For count classify errors on testing A data
class_2_error = 0;      % For count classify errors on testing B data
class_3_error = 0;      % For count classify errors on testing C data

%////////////////////// CLAS 1 DESICION MAKING   //////////////////////////

% Get the row number (postion) from all the testing epochs in cross-validation
% to start saving probability values for this cross-validation iteration
temp_pos = (param.crossv_num_test_epochs(1)*(param.crossv_iteration - 1));

for j=1:param.crossv_num_test_epochs(1) % A and B testing epochs simultaneosly
    
    % TESTING EPOCH J POR TESTING A DATA
    % Log of the values
    P1 = sum(log(sec_A_test_sample_prob_A(j,:)));
    P2 = sum(log(sec_A_test_sample_prob_B(j,:)));
    P3 = sum(log(sec_A_test_sample_prob_C(j,:)));
    
    % Save probabilities
    param.test_epoch_prob_values(temp_pos + j,1) = sum(P1);
    param.test_epoch_prob_values(temp_pos + j,2) = sum(P2);
    param.test_epoch_prob_values(temp_pos + j,3) = sum(P3);
    
    % Make decision (count errors)
    % The testing epoch is Class 1, but classifier says 2 or 3. Count error
    max_freq = max([P1, P2, P3]);
    if ( max_freq ~= P1)
        class_1_error = class_1_error + 1;
    end
    
end
tmp_val = class_1_error/param.crossv_num_test_epochs(1);
disp(['Error rate for class 1:', num2str(tmp_val)]);


%////////////////////// CLAS 2 DESICION MAKING   //////////////////////////

% Get the row number (postion) from all the testing epochs in cross-validation
% to start saving probability values for this cross-validation iteration
temp_pos = temp_pos + (param.crossv_num_test_epochs(2)*(param.crossv_iteration - 1));

for j=1:param.crossv_num_test_epochs(2) % A and B testing epochs simultaneosly
    
    % TESTING EPOCH J POR TESTING A DATA
    % Log of the values
    P1 = sum(log(sec_B_test_sample_prob_A(j,:)));
    P2 = sum(log(sec_B_test_sample_prob_B(j,:)));
    P3 = sum(log(sec_B_test_sample_prob_C(j,:)));
    
    % Save probabilities
    param.test_epoch_prob_values(temp_pos + j,4) = sum(P1);
    param.test_epoch_prob_values(temp_pos + j,5) = sum(P2);
    param.test_epoch_prob_values(temp_pos + j,6) = sum(P3);
    
    % Make decision (count errors)
    % The testing epoch is Class 2, but classifier says 1 or 3. Count error
    max_freq = max([P1, P2, P3]);
    if ( max_freq ~= P2)
        class_2_error = class_2_error + 1;
    end
        
end
tmp_val = class_2_error/param.crossv_num_test_epochs(2);
disp(['Error rate for class 2:', num2str(tmp_val)]);



%////////////////////// CLAS 3 DESICION MAKING   //////////////////////////

% Get the row number (postion) from all the testing epochs in cross-validation
% to start saving probability values for this cross-validation iteration
temp_pos = temp_pos + (param.crossv_num_test_epochs(3)*(param.crossv_iteration - 1));

for j=1:param.crossv_num_test_epochs(3) % A and B testing epochs simultaneosly
    
    % TESTING EPOCH J POR TESTING A DATA
    % Log of the values
    P1 = sum(log(sec_C_test_sample_prob_A(j,:)));
    P2 = sum(log(sec_C_test_sample_prob_B(j,:)));
    P3 = sum(log(sec_C_test_sample_prob_C(j,:)));
    
    % Save probabilities
    param.test_epoch_prob_values(temp_pos + j,7) = sum(P1);
    param.test_epoch_prob_values(temp_pos + j,8) = sum(P2);
    param.test_epoch_prob_values(temp_pos + j,9) = sum(P3);
    
    % Make decision (count errors)
    % The testing epoch is Class 3, but classifier says 2 or 1. Count error
    max_freq = max([P1, P2, P3]);
    if ( max_freq ~= P3)
        class_3_error = class_3_error + 1;
    end
    
end
tmp_val = class_3_error/param.crossv_num_test_epochs(3);
disp(['Error rate for class 3:', num2str(tmp_val)]);



% Finally, calcualte the total error rate
error_rate = ( (class_1_error + class_2_error + class_3_error))/(sum(param.crossv_num_test_epochs));         
end

