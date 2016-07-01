function auc = ExtractAUCByCV(Results)

for i = 1:length(Results)
    
    for j = 1:length(Results{i}.testPerformance)
        auc(i, j) = Results{i}.testPerformance{j}.Az;
    end

    
end