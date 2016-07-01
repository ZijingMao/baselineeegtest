function conf_struct = new_bow_model(conf_struct)
% Testing the new implementation of the bag-of-words model


%---------  LOAD SPECIFIED EEG DATASET, EXTRACT RAW SECTIONS  -------------
% Load Patrol Mission, get event's location
dataset_name = char(['TX16EEGdata.filt.00', int2str(conf_struct.data_mission),...
    '.0',int2str(conf_struct.data_subject), '.',int2str(conf_struct.data_mission),'.set']);
current_dataset = pop_loadset(dataset_name);       % EEGLAB function to load
current_signal = current_dataset.data;             % Preprocesed EEG data
[~,events_quantity] = size(current_dataset.event); % # of events
event_location = zeros(2,events_quantity);         % Latency points and time locs
for i=1:events_quantity                    
    event_location(1,i) = current_dataset.event(i).latency;
    event_location(2,i) = ((current_dataset.event(i).latency)/(256))/60;
end


%---------  PERFORM ANALYSIS  -------------
classes_names = cell(1,conf_struct.number_classes);  % Cell containing the names
classes_data(conf_struct.number_classes).Data = 0;   % Struct with class information
conf_struct.size_classes = zeros(conf_struct.number_classes, 3);
for i=1:conf_struct.number_classes
    
    % Extract data
    var = (i - 1) + 1;
    temp_data = current_signal(:,event_location(1,conf_struct.classifier_classes(var)):...
    event_location(1,conf_struct.classifier_classes(var+1)));
    
    % Save the size to the struct
    conf_struct.size_classes(i,1) = i;
    [conf_struct.size_classes(i,2), conf_struct.size_classes(i,3)] = size(temp_data);
    
    % Display message
    clc
    disp(['EEG DATA HAVE BEEN EXTRACTED SUCCESSFULLY FOR CLASS ', num2str(i)]);
    disp('               ');
    
    % Time-Frequency Analysis
    TF_temp = time_freq(temp_data);
    
    % Display message
    clc
    disp(['TIME-FREQUENCY ANALYSIS COMPLETED FOR CLASS ', num2str(i)]);
    disp('               ');
    
    % Extract significant data
    R_temp = extract_disc_data(TF_temp, conf_struct.number_features);
    
    % Display message
    clc
    disp(['EXTRACTION OF RELEVANT DATA COMPLETED FOR CLASS ', num2str(i)]);
    disp('               ');
        
    
    % Generate class variable and copy the result
    classes_names{i} = char(['class_', num2str(i)]);   % Add the name to the cell
    eval([classes_data(i).Data ' = R_temp']);
    
end


%------------------    IMPORTANT INFORMATION     --------------------------
% At this point, more of one alternative for Bag-of-Words will be tested.
% Each one on a different function

% Call the alternative 1 function (based on previous bag-of-words)
conf_struct = bow_alternative1(conf_struct, classes_data);



end

