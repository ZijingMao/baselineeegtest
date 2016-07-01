function [section_A, section_B] = load_patrol_sections(conf_struct)
% Load the defined subject and mission from the database, extract the
% section A and section B data as indicated by user, calculate training and
% testing data size and check them for errors using the epoch size and
% crossvaidation fold contained on the config. struct.
% Mauricio Merino, Jia Meng, UTSA 2011

%---------------------   DISPLAY TARGET MESSAGE   ------------------------
% Generate dataset name and show a visual confirmation
addpath(genpath(pwd));          % Add to the path all subdirectories
dataset_name = char(['TX16EEGdata.filt.00',...
    int2str(conf_struct.TX_mission),'.0',int2str(conf_struct.TX_subject),...
    '.',int2str(conf_struct.TX_mission),'.set']);

display_name = char(['Reading Dataset: ',int2str(conf_struct.TX_mission),...
    ' Mission from  ',int2str(conf_struct.TX_subject),' subject']);

disp('*****************************************');
disp(display_name);
disp('*****************************************');

%--------------------   LOAD DATASETA ND EXTRACT EVENTS  -----------------
% Load current dataset, using EEGLAB function

current_dataset = pop_loadset(dataset_name);
% Extract info from the de EEGLAB-format loaded dataset
current_signal = current_dataset.data;             % Preprocesed EEG data
[~,events_quantity] = size(current_dataset.event); % # of events
event_location = zeros(2,events_quantity);       % Points and time locs
for i=1:events_quantity                    
    % Get latency in points AND time (minutes)
    % Time = (latency(points) / sampling rate (256) / 60 (minutes)
    event_location(1,i) = current_dataset.event(i).latency;
    event_location(2,i) = ((current_dataset.event(i).latency)/...
        current_dataset.srate)/60;
end

%---------------------   EXTRACT THE 2 SECTIONS DATA  -------------------
% Extract some data from the active and non-active group
% Section A from the NON-ACTIVE group = section 1 of the mission
section_A = current_signal(:,event_location(1,conf_struct.sec1(1)):...
    event_location(1,conf_struct.sec1(2)));
sA_size = length(section_A);

% Section B from the ACTIVE group = section 4 of the mission
section_B = current_signal(:,event_location(1,conf_struct.sec2(1)):...
    event_location(1,conf_struct.sec2(2)));
sB_size = length(section_B);

% make both samples with the same size (lenght for the smallest sample)
if (sA_size > sB_size)
    section_A = section_A(:,1:sB_size);
else
    section_B = section_B(:,1:sA_size);
end
disp('Sections extracted successfully');


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
 if ( (sec_size/patrol_bow.crossv_fold) < patrol_bow.epochs_per_section) 
     exception = MException('VerifyOutput:OutOfBounds',...
         'Error: Invalid configuration of fold cross-validation & epoch size');
     throw(exception);
 end
 disp('No errors on epoc configuration');
 

% --- INCLUDE IMPORTANT VARIABLES TO THE CONFIG. + RESULTS STRUCT --------- 
conf_struct.section_size = section_size;        
conf_struct.crossv_test_size = crossv_test_size;
conf_struct.crossv_num_test_epochs = crossv_num_test_epochs;
conf_struct.crossv_num_trai_epochs = crossv_num_trai_epochs;
conf_struct.nwords = conf_struct.model_selection(1):conf_struct.model_selection(2);
conf_struct.crossv_error_rates = zeros(2,length(conf_struct.nwords));
conf_struct.all_error_rate = zeros(1,(length(conf_struct.nwords)*conf_struct.crossv_fold));
disp('Configuration struct updated');


end