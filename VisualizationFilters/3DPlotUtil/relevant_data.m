function similarity_matrix = relevant_data(input_arg)
% This function receives the [Channel - Frequency - Time] training and
% testing data for the A and B sections and perform Two sample T- test to
% find discriminat features between trainig data samples; then rank the top
% n (defined by user) discriminant feaures and extract the time points for
% the discriminat time - frequency pairs. Same combinations are used for 
% extract the time points for the testing data. UTSA, 2011.


%------- Find discrimant features with T-test and rank Top-N (input) ------
% Pre-allocate  result datasets
[chan,freq,~] = size(input_arg);

% Two sample T-test for class data
similarity_matrix = zeros((chan*freq)+1, (chan*freq)+1);
for x = 1:chan
    for y = 1:freq
        for i = 1:chan
            for j = 1:freq
                
                % T-test for all the posible combinations Chan - Freq.
                [~,~,~,stats] = ttest2(input_arg(x,y,:), input_arg(i,j,:));
                similarity_matrix( ((x*y)+1), ((i*j)+1) ) = stats.tstat;
                
            end
        end
    end
end
               


end

