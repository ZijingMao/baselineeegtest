function [Dictionary, words_info] = new_clustering(N, EEG_data)
% Function in development


% Find the maximun and minimum values from EEG data
biggest_val = max(max(EEG_data));
smallest_val = min(min(EEG_data));

% Create ranges according to the number of words
step_unit = (biggest_val - smallest_val)/N;
word_ctrs = smallest_val:step_unit:biggest_val;
word_ctrs = word_ctrs(1:N);
word_ctrs(N) = biggest_val;

% Pre-allocate variables
[~,columns] = size(EEG_data);
Dictionary = zeros(1, columns);

matlabpool open

% Locate every column of EEG data into a designated range (parallel)
parfor id=1:columns
    
    col_mean = mean(EEG_data(:,id));
    col_distances = abs(col_mean - word_ctrs);
    var1 = min(col_distances);
    var2 = find(col_distances == var1);
    col_word = var2(1);
    Dictionary(id) = col_word;
          
end

matlabpool close


% Collect information about data that belongs to echa word and save it
words_info(N).word_number = N;
for id=1:N
    
    words_info(id).word_number = id;
    
    % How many columns belongs to the current word
    tmp = Dictionary == id;
    
    if sum(sum(tmp)) == 0
        
        words_info(id).ncolumns = 0;
    else
        
        % Collect information about the data
        words_info(id).ncol = sum(sum(tmp));
        word_data = EEG_data(tmp);
        words_info(id).mean = mean(mean(word_data));
        words_info(id).Maximum = max(max(word_data));
        words_info(id).Minimum = min(min(word_data));
        words_info(id).Sd = std(std(word_data));
        words_info(id).Minimum = median(median(word_data));
        words_info(id).Energy = sum(sum(word_data.^2));
        words_info(id).SC = sum(sum(fft(word_data)));
        
    end
    
end

end

