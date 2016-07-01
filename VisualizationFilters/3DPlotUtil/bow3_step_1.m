function [section_A, section_B, conf_struct] = bow3_step_1(conf_struct)
% Load the defined subject and mission from the database, extract the
% section A and section B data as indicated by user, calculate training and
% testing data size and check them for errors using the epoch size and
% cross vaidation fold contained on the config. struct.


raw_section_A = 0;
raw_section_B = 0;
load test_1


% Crop sections for save time and finish development
raw_section_A = raw_section_A(:,1:40000);
raw_section_B = raw_section_B(:,1:40000);

%------------------  ORGANIZE THE EPOCHS INFORMATION  ---------------

%///// First class = Human-moving target images (with some non-target) ////
[chan, n1, n2] = size(raw_section_A);
section_A = zeros(chan, n1*n2);

for i=1:n2
    v1 = n1*(i-1) + 1;
    v2 = n1*i;
    section_A(:,v1:v2) = raw_section_A(:,:,i);
end


%///// Second class = HFull of Non-target images ////
[chan, n1, n2] = size(raw_section_B);
section_B = zeros(chan, n1*n2);

for i=1:n2
    v1 = n1*(i-1) + 1;
    v2 = n1*i;
    section_B(:,v1:v2) = raw_section_B(:,:,i);
end

%------------------  CALCULATE TRAINING AND TESTING SIZE  ---------------
% Sections length
[~,section_size] = size(section_A);                        

% Size of the testing data   
crossv_test_size = floor(section_size/conf_struct.crossv_fold); 

% Number of testing epochs 
crossv_num_test_epochs = floor(crossv_test_size/conf_struct.epochs_per_section);            

% Number of training epochs
crossv_num_trai_epochs = floor( (crossv_test_size*(conf_struct.crossv_fold - 1))/...
    conf_struct.epochs_per_section);            

% Check for error on the user configuration, at least 2 testing epoch
 if ( (section_size/conf_struct.crossv_fold) < conf_struct.epochs_per_section) 
     exception = MException('VerifyOutput:OutOfBounds',...
         'Error: Invalid configuration of fold cross-validation & epoch size');
     throw(exception);
 end
 disp('No errors on epoch configuration');
 

% --- INCLUDE IMPORTANT VARIABLES TO THE CONFIG. + RESULTS STRUCT --------- 
conf_struct.section_size = section_size;        
conf_struct.crossv_test_size = crossv_test_size;
conf_struct.crossv_num_test_epochs = crossv_num_test_epochs;
conf_struct.crossv_num_trai_epochs = crossv_num_trai_epochs;
conf_struct.nwords = conf_struct.model_selection(1):conf_struct.model_selection(2);
conf_struct.crossv_error_rates = zeros(2,length(conf_struct.nwords));
conf_struct.all_error_rate = zeros(1,(length(conf_struct.nwords)*conf_struct.crossv_fold));
disp('Configuration struct updated');
disp('                                         ');
disp('                                         ');

end