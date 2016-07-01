function [XDBLDA, XDBLDApredictions, XDBLDAconfidence] = ProcessXDBLDA_Continuous(data, train, test, options, currIndex, XDBLDA)

options.trainTRG = train.trg;
options.trainNTG = train.ntg;
options.param.decimation = 16;
options.param.decimation1 = 4;
options.param.decimation2 = 4;
options.nfilters = 8;

%options.param.epoch(1) = 0;

[dataClassA, dataClassB, ReRef] = PreProcessXDBLDA(data, options);

if isfield(options, 'useArtificialTrials') && (options.useArtificialTrials)  && (mod(currIndex, options.BoostPeriod)==0)
    disp('XD: artificialTrials');
    dataTrainA = CreateArtificialTrials(dataClassA(:, :, train.trg),options.param.sampleRate/ options.param.decimation,1,1);
    dataTrainB = CreateArtificialTrials(dataClassB(:, :, train.ntg),options.param.sampleRate/ options.param.decimation,1,1);
else
    dataTrainA = dataClassA(:, :, train.trg);
    dataTrainB = dataClassB(:, :, train.ntg);
end



[XDBLDAweights, XDBLDAperformance] = TrainXDBLDA(dataTrainB, dataTrainA, options);


% test
for i = 1 : length(test.trg)
    [XDBLDAscoreT(i), XDBLDApredictionsT(i)] = TestXDBLDA(dataClassA(:,:,test.trg(i)), options, XDBLDAweights);
end



for i = 1 : length(test.ntg)
    [XDBLDAscoreN(i), XDBLDApredictionsN(i)] = TestXDBLDA(dataClassB(:,:,test.ntg(i)), options, XDBLDAweights);
end

if isfield(options, 'ValidationIndices')
   
    options.ValidationIndices.param.epoch = options.param.epoch;
    options.ValidationIndices.useNewSpatialFilter = 0;
    options.ValidationIndices.XDBLDAFilter = ReRef;
    options.ValidationIndices.param.sampleRate = options.param.sampleRate;
    options.ValidationIndices.filterOrder = options.filterOrder;
    options.ValidationIndices.lpf = options.lpf;
    options.ValidationIndices.hpf = options.hpf;
    options.ValidationIndices.param.decimation1 = 4;
    options.ValidationIndices.param.decimation2 = 4;
    options.ValidationIndices.param.decimation = 16;
    options.ValidationIndices.param.nfilters = 8;
    
    [dataValidationA, dataValidationB, ~] = PreProcessXDBLDA(data, options.ValidationIndices);
    
    for i = 1 : size(dataValidationA, 3)
        [XDBLDAValidationscoreT(i), XDBLDAValidationpredictionsT(i)] = TestXDBLDA(dataValidationA(:,:,i), options.ValidationIndices, XDBLDAweights);
    end
    
    
    
    for i = 1 : size(dataValidationB, 3)
        [XDBLDAValidationscoreN(i), XDBLDAValidationpredictionsN(i)] = TestXDBLDA(dataValidationB(:,:,i), options.ValidationIndices, XDBLDAweights);
    end
    
    XDBLDAValidationscore = [XDBLDAValidationscoreT XDBLDAValidationscoreN];
    GroupValidation = [zeros(1, length(XDBLDAValidationscoreT)) ones(1, length(XDBLDAValidationscoreN))];
    XDBLDA.Validation_AUC(currIndex) = rocarea(XDBLDAValidationscore, GroupValidation);
end




% measure performance
XDBLDAscore = [XDBLDAscoreT XDBLDAscoreN];
XDBLDApredictions = [XDBLDApredictionsT XDBLDApredictionsN];
XDBLDAconfidence = calculateConfidence(XDBLDAscore, XDBLDAweights.threshold);
Group = [zeros(1, length(XDBLDAscoreT)) ones(1, length(XDBLDAscoreN))];
XDBLDA.accuracy(currIndex) = (length(find(XDBLDApredictionsT == 0)) + length(find(XDBLDApredictionsN == 1))) / (size(dataClassA, 3) + size(dataClassB, 3));
XDBLDA.AUC(currIndex) = rocarea(XDBLDAscore, Group);


XDBLDA.target_accuracy(currIndex) = 1-(sum(XDBLDApredictionsT)/length(XDBLDApredictionsT));
XDBLDA.nontarget_accuracy(currIndex) = sum(XDBLDApredictionsN)/length(XDBLDApredictionsN);


XDBLDA.ReRef{currIndex} = ReRef;
XDBLDA.CurrTrainTRG{currIndex} = train.trg;
XDBLDA.CurrTrainNTG{currIndex} = train.ntg;


