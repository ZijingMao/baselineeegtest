function [hitRate, corrRejRate] = ExtractAccuracyReal(Results, order)

if order == 1
    classATag = 1;
    classBTag = 0;
else
    classATag = 0;
    classBTag = 1;
end
for subj = 1:length(Results)
    for cv = 1:length(Results{subj}.testPerformance)
        performance = Results{subj}.testPerformance{cv};
        
        classAInd = find(performance.groups == classATag);
        classBInd = find(performance.groups == classBTag);
        
        classASum = sum(performance.predictions(classAInd));
        classBSum = sum(performance.predictions(classBInd));
        
        if (order == 1)
            hitRate(subj, cv) = classASum / length(classAInd);
            corrRejRate(subj, cv) = 1- (classBSum /  length(classBInd));
        else
            hitRate(subj, cv) = 1 - (classASum / length(classAInd));
            corrRejRate(subj, cv) = (classBSum /  length(classBInd));
        end
        
        
        
    end
end