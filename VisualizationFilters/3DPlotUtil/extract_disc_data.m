function disc_data = extract_disc_data(dataset, N)
% Function to apply two sample t-test in every combination of channel -
% frecuency of the EEG data to find relevant and very similar pairs. Then
% significant data is extracted.


% Size of Dataset
[ncha, nfreq, nsamples] = size(dataset);   

% Array with row, column values for the 1 to channel*freq scale
scale1 = zeros(3, ncha*nfreq);
tmp = 0;
for i=1:ncha
    for j=1:nfreq
        
        tmp = tmp+1;
        scale1(1, tmp) = tmp;
        scale1(2, tmp) = i;
        scale1(3, tmp) = j;
    end
end

% Open the pool of workers to calculate t-test parallely on cpu cores
matlabpool open

% Pre-allocate similiarty matrix
similarity_matrix = zeros(tmp, tmp);
vec = zeros(1, tmp);
disp('Search Relevant Features in Dataset');

% Calculate similarity in all channel - freq, combinatios
for i=1:tmp
    
    % Extract the current fixed time sample array to be extracted
    array1 = dataset(scale1(2,i), scale1(3,i),:);
    
    % Display a progress message
    disp(['Completed ', num2str(i), ' of ', num2str(tmp)]);
    
    parfor j=1:tmp
        
        % Extract array2, data samples that changes with every iteration
        array2 = dataset(scale1(2,j), scale1(3,j),:);
        
        % Two sample t-test
        [~,~,~,stats] = ttest2(array1, array2);
        vec(j) = abs(stats.tstat);
    end
    
    % Copy obtained results to the similarity matrix
    similarity_matrix(i,:) = vec;
    
end

% close pool of workers
matlabpool close  


% Eliminate redundances (values = zero)
tmp = similarity_matrix == 0;
similarity_matrix(tmp) = max(max(similarity_matrix));

% Pre-allocate discriminant data
disc_data = zeros(N, nsamples);

% Search the channel and frequency locations of the Top N small t-test
% values.
top_elements = 0;

while top_elements < N
    
    % Get the current smallest value
    local_min = min(min(similarity_matrix));
    
    % find out how many elements share the smallest t-value
    tmp = similarity_matrix == local_min;
    num = sum(sum(tmp));
    
    % Extract the row and column location (in the chan*freq scale) and
    % translate it into a chan, freq location
    locs = zeros(2, num);
    subs = find(tmp);
    [locs(1,:), locs(2,:)] = ind2sub([(ncha*nfreq), (ncha*nfreq)], subs);
    row = locs(1,1);
    column = locs(2,1);
    
    % Find and convert subs
    chan1 = scale1(2,row);
    freq1 = scale1(3,row);
    chan2 = scale1(2,column);
    freq2 = scale1(3,column);
         
    % Copy data from the channels and freqs to the result matrix
    top_elements = top_elements + 1;
    disc_data(top_elements,:) = dataset(chan1, freq1,:);
    top_elements = top_elements + 1;
    disc_data(top_elements,:) = dataset(chan2, freq2,:);
        
    % Delete the current smallest value, so the second one will be next
    similarity_matrix(tmp) = max(max(similarity_matrix));
    
end

