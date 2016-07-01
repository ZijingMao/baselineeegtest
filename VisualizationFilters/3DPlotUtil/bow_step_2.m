function [analyized_secA, analyized_secB] = bow_step_2(raw_section_A, raw_section_B)
% Function for apply time-frequency analysis (based on wavelet transform)

%----------------- CONFIGURE AND USE, JIA'S FUNCTION --------------------
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
Y2A = cell(1,2);
Y2A{1} = raw_section_A;
Y2A{2} = raw_section_B;

% Time-frequency anaylisis for the A & B raw data sections
% Apply function
PSD2 = bow_TFA(Y2A,parameter);


%-------------------   GET THE RESULTS   ---------------------   
% Extract the new data (Channel x Frequency x Time) for training
analyized_secA = PSD2{1};
analyized_secB = PSD2{2};
       
end
    
