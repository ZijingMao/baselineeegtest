function [analyized_secA, analyized_secB, analyized_secC] = bow2_step_2(raw_section_A, raw_section_B, raw_section_C)
% Function for apply time-frequency analysis (based on wavelet transform)
% VERSION 2 FOR 3 CLASSES/2012


%----------------- CONFIGURE AND USE, JIA'S FUNCTION --------------------

%//////////////  CLASS 1   //////////////////////////
% Set up parameters to perfomr Jia's Method 
parameter.PSD_frequencies_width=[2,40]; 
parameter.PSD_frequencies_no=10; 
parameter.PSD_down_sampling=1; 
parameter.sampling_frequency=256; 
parameter.log_PSD='Y'; 
parameter.PSD_normalization=0; 
parameter.start_time=1; 
parameter.end_time=length(raw_section_A(1,:));

% Generate Cell for A & B Sections
Y2A = cell(1,1);
Y2A{1} = raw_section_A;

% Time-frequency anaylisis for the A & B raw data sections
% Apply function
PSD2 = calculate_PSD_1(Y2A,parameter);

% Extract the new data (Channel x Frequency x Time) for training
analyized_secA = PSD2{1};


%//////////////  CLASS 2   //////////////////////////
% Set up parameters to perfomr Jia's Method 
parameter.PSD_frequencies_width=[2,30]; 
parameter.PSD_frequencies_no=10; 
parameter.PSD_down_sampling=1; 
parameter.sampling_frequency=256; 
parameter.log_PSD='Y'; 
parameter.PSD_normalization=0; 
parameter.start_time=1; 
parameter.end_time=length(raw_section_B(1,:));

% Generate Cell for A & B Sections
Y2A = cell(1,1);
Y2A{1} = raw_section_B;

% Time-frequency anaylisis for the A & B raw data sections
% Apply function
PSD2 = calculate_PSD_1(Y2A,parameter);

% Extract the new data (Channel x Frequency x Time) for training
analyized_secB = PSD2{1};

%//////////////  CLASS 3   //////////////////////////
% Set up parameters to perfomr Jia's Method 
parameter.PSD_frequencies_width=[2,30]; 
parameter.PSD_frequencies_no=10; 
parameter.PSD_down_sampling=1; 
parameter.sampling_frequency=256; 
parameter.log_PSD='Y'; 
parameter.PSD_normalization=0; 
parameter.start_time=1; 
parameter.end_time=length(raw_section_C(1,:));

% Generate Cell for A & B Sections
Y2A = cell(1,1);
Y2A{1} = raw_section_C;

% Time-frequency anaylisis for the A & B raw data sections
% Apply function
PSD2 = calculate_PSD_1(Y2A,parameter);

% Extract the new data (Channel x Frequency x Time) for training
analyized_secC = PSD2{1};

end

       