function [score, prediction] = TestXDBLDA(data, options, weights)


% reshape the epochs so that components are stacked temporally
dataReshaped = [];

for i = 1:options.param.nfilters
    dataReshaped = [dataReshaped; squeeze(double(data(i, :, :)))'];
end



score = classify_BLDA(weights, dataReshaped )';
if (score > weights.threshold)
    prediction = 1;
else
    prediction = 0;
end