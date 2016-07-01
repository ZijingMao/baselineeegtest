function [section_A, section_B, section_C, conf_struct] = bow2_step_1(conf_struct)
% Load the defined subject and mission from the database, extract the
% section A and section B data as indicated by user, calculate training and
% testing data size and check them for errors using the epoch size and
% cross vaidation fold contained on the config. struct.
% VERSION 2 FOR 3 CLASSES/2012

%---------------------   DISPLAY TARGET MESSAGE   ------------------------
% Generate dataset name and show a visual confirmation
addpath(genpath(pwd));          % Add to the path all sub-directories
dataset_name = char(['TX16EEGdata.filt.00',...
    int2str(conf_struct.TX_mission),'.0',int2str(conf_struct.TX_subject),...
    '.',int2str(conf_struct.TX_mission),'.set']);

display_name = char(['Reading Dataset: ',int2str(conf_struct.TX_mission),...
    ' Mission from  ',int2str(conf_struct.TX_subject),' subject']);

disp('*****************************************');
disp(display_name);
disp('*****************************************');
disp('                                         ');
disp('                                         ');
disp('                                         ');

%--------------------   LOAD DATASETA AND EXTRACT EVENTS  -----------------
% Load current dataset, using EEGLAB function
current_dataset = pop_loadset(dataset_name);

% Extract info from the de EEGLAB-format loaded dataset
current_signal = current_dataset.data;             % Preprocesed EEG data

[~,events_quantity] = size(current_dataset.event); % # of events
event_location = zeros(2,events_quantity);       % Latency points and time locs
for i=1:events_quantity                    
    % Get latency in points AND time (minutes)
    % Time = (latency(points) / sampling rate (256) / 60 (minutes)
    event_location(1,i) = current_dataset.event(i).latency;
    event_location(2,i) = (event_location(1,i)/256)/60;
end

%---------------------   EXTRACT THE 3 SECTIONS DATA  -------------------
% Extract some data from the active and non-active group

% Section A from the LOW TASK LOAD (now called also background) = section 1 of the mission
section_A = current_signal(:,event_location(1,conf_struct.sec1(1)):...
    event_location(1,conf_struct.sec1(2)));

% Section B from the HIGH TASK LOAD group = section 4 of the mission
section_B = current_signal(:,event_location(1,conf_struct.sec2(1)):...
    event_location(1,conf_struct.sec2(2)));

% Section C from the MIXED TASKLOAD group = Last section of the mission
section_C = current_signal(:,event_location(1,conf_struct.sec3(1)):...
    event_location(1,conf_struct.sec3(2)));
disp('Sections extracted successfully');


%------------------  CALCULATE TRAINING AND TESTING SIZES  ---------------                  
% Define sizes variables (MODIFY THIS LATER FOR N-CLASS VERSION)*******
n_classes = 3;   % integrate this with the parameters struct for next version
crossv_test_size = zeros(1,n_classes);
crossv_num_test_epochs = zeros(1,n_classes);
crossv_num_trai_epochs = zeros(1,n_classes);
section_size = zeros(1,n_classes);


%//////// CLASS 1 (SECTION A)

% Sections length
[~,section_size(1)] = size(section_A);     

% Size of the testing data   
crossv_test_size(1) = floor(section_size(1)/conf_struct.crossv_fold); 

% Number of testing epochs 
crossv_num_test_epochs(1) = floor(crossv_test_size(1)/conf_struct.epochs_per_section);            

% Number of training epochs
crossv_num_trai_epochs(1) = floor( (crossv_test_size(1)*(conf_struct.crossv_fold - 1))/...
    conf_struct.epochs_per_section);    


%//////// CLASS 2 (SECTION B)

% Sections length
[~,section_size(2)] = size(section_B);     

% Size of the testing data   
crossv_test_size(2) = floor(section_size(2)/conf_struct.crossv_fold); 

% Number of testing epochs 
crossv_num_test_epochs(2) = floor(crossv_test_size(2)/conf_struct.epochs_per_section);            

% Number of training epochs
crossv_num_trai_epochs(2) = floor( (crossv_test_size(2)*(conf_struct.crossv_fold - 1))/...
    conf_struct.epochs_per_section);


%//////// CLASS 3 (SECTION C)

% Sections length
[~,section_size(3)] = size(section_C);     

% Size of the testing data   
crossv_test_size(3) = floor(section_size(3)/conf_struct.crossv_fold); 

% Number of testing epochs 
crossv_num_test_epochs(3) = floor(crossv_test_size(3)/conf_struct.epochs_per_section);            

% Number of training epochs
crossv_num_trai_epochs(3) = floor( (crossv_test_size(3)*(conf_struct.crossv_fold - 1))/...
    conf_struct.epochs_per_section);


%------------------  CHECK FOR ERRORS AND SAVE VARIABLES  ---------------
% Check for error on the user configuration, at least 2 testing epoch
 if ( (section_size(1)/conf_struct.crossv_fold) < conf_struct.epochs_per_section) 
     exception = MException('VerifyOutput:OutOfBounds',...
         'Error for Class 1 (Section 1) Invalid configuration of fold cross-validation & epoch size');
     throw(exception);
 end
 disp('No errors on epoch configuration for Class 1 (Section 1) ');
 
 if ( (section_size(2)/conf_struct.crossv_fold) < conf_struct.epochs_per_section) 
     exception = MException('VerifyOutput:OutOfBounds',...
         'Error for Class 2 (Section 4) Invalid configuration of fold cross-validation & epoch size');
     throw(exception);
 end
 disp('No errors on epoch configuration for Class 2 (Section 4) ');
 
 if ( (section_size(3)/conf_struct.crossv_fold) < conf_struct.epochs_per_section) 
     exception = MException('VerifyOutput:OutOfBounds',...
         'Error for Class 3 (Section 8) Invalid configuration of fold cross-validation & epoch size');
     throw(exception);
 end
 disp('No errors on epoch configuration for Class 3 (Section 8) ');
 

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