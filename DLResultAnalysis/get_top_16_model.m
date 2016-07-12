function [top16_val, top16_model] = ...
    get_top_16_model(validAUCAll, testAUCAll, setFilesList, topSize)

[i,j]=find(validAUCAll == max(max(validAUCAll)));

best_perm = testAUCAll(i,j);
disp(['best model: ' setFilesList(i)]);
disp(['best perfm: ' num2str(best_perm)]);
% max(max(validAUCAll))

% [i,j]=find(testAUCAll == max(max(testAUCAll)));
% a = testAUCAll(i, 1:j);
% a = a';

test_list = max(testAUCAll, [], 2);
[test_list_sort_val, test_list_sort_idx] = sort(test_list);

top16_model = setFilesList(test_list_sort_idx(end-topSize+1:end));
top16_val = test_list_sort_val(end-topSize+1:end);


end