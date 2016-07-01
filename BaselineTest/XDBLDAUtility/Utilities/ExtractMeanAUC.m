function az = ExtractMeanAUC(Results)

for i = 1:length(Results)
    az(i) = Results{i}.MeanAz;
end