function [weights, performance] = TrainXDBLDA(dataClassA, dataClassB, options)



% reshape the epochs so that components are stacked temporally
dataA = [];
dataB = [];
for i = 1:options.param.nfilters
    dataA = [dataA; squeeze(double(dataClassA(i, :, :)))];
    dataB = [dataB; squeeze(double(dataClassB(i, :, :)))];
    
end

% save the number of events for each class
nA=size(dataA,2);
nB=size(dataB,2);

blockLengthSamples = floor((options.sampleRate) / options.param.decimation);


nTG_Classifier=nA;
nNTG_Classifier=nB;

if nA>nB
    stdBruit = min(std(dataA, [] , 2)) * 1e-2; % default case 
    indexSelected  = mod(randperm(nA-nB),nB)+1;
    dataClassA = dataA; 
    dataClassB = [dataB(:,indexSelected)+stdBruit*randn(options.param.nfilters*blockLengthSamples,length(indexSelected)) , dataB];
else    
    stdBruit = min(std(dataB, [] , 2)) * 1e-2; % default case
    indexSelected  = mod(randperm(nB-nA),nA)+1;
   
    dataClassA = [dataA , dataA(:,indexSelected)+stdBruit*randn(options.param.nfilters*blockLengthSamples,length(indexSelected))];
    dataClassB = dataB;
end



% define the number of samples for the classifier
nA_Classifier = max(nA,nB);
nB_Classifier = nA_Classifier; 
         
inData = [dataClassA dataClassB];

Group = [ones(1,nA_Classifier) -1*ones(1,nB_Classifier)];

% train the classifier on the training dataset

%BLDA classifier
BLDA = bayeslda(1);
BLDA.verbose = 0;
BLDA = train_BLDA(BLDA, inData, Group);

weights = BLDA;



performance.group = Group';
performance.score = classify_BLDA(weights, inData )';

if (isfield(options, 'EventBG'))
    civInds = options.EventBG + nA_Classifier;
    insInds = 1:size(dataA, 2);
    goodInds = [insInds civInds];
    weights.threshold = findThreshold(performance.score(goodInds), Group(goodInds));
    weights.thresholdOrig = findThreshold(performance.score, Group);
    
else
    
    weights.threshold = findThreshold(performance.score, Group);
end






