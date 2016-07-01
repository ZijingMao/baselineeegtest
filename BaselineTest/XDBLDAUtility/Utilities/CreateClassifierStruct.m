function [classifier] = CreateClassifierStruct(classifierName, sampleRate, epochSize, channels, ClassA, ClassB)

%% CreateClassifierStruct
% This function will create a classifier struct specific to the classifier
% name given in the input string. The classifier struct will be
% pre-populated with default parameters that may be modified before calling
% TrainClassifier or RunClassifier.
%%
% make sure string is all uppercase letters
classifierName = upper(classifierName);

classifier.CVType = 1; % 1 = n-fold temporally contiguous; 2 = n-fold random; 3 = leave out 1; 4 = n-fold temporally contiguous with m-validation sets % 5 = 2 validation 6 = heirarchecal; 7 = custom



% prepopulate non specific parameters
classifier.numCVSets = 10;
classifier.numCVSetsForValidation = 1;
classifier.numCVSetsForTest = 4;
classifier.param.sampleRate = sampleRate;

% prepopulate state variables
classifier.isPreProcessed = 0;
classifier.isTrained = 0;

classifier.param.epoch = epochSize;
classifier.param.electrodes = channels;

classifier.codes.ClassA = ClassA;
classifier.codes.ClassB = ClassB;
classifier.param.decimation = 1;
classifier.param.groupOrder = 1;
classifier.param.removeBaseline = 1;
classifier.param.trainAll = 1;
classifier.param.trainSetA = [];
classifier.param.trainSetB = [];

switch classifierName
    case 'HDCA'
        classifier.train = @TrainHDCA;
        classifier.test = @TestHDCA;
        classifier.preProcess = @PreProcessExtractEpochs;
        
        classifier.param.numTimeSlices = 20;
        classifier.param.nWindows = -1;
        
        classifier.param.decimation = 1;
        
        classifier.param.decimation1 = 1;
        classifier.param.decimation2 = 1;
        
        classifier.lpf = 10.667;
        classifier.hpf = 0.1;
        classifier.filterOrder = 4;
        
        
    case 'SLIDINGHDCA'
        classifier.train = @TrainSlidingHDCA;
        classifier.test = @TestSlidingHDCA;
        classifier.preProcess = @PreProcessExtractEpochs;
        
        classifier.param.epochZeroOffset = 0.5;
        classifier.param.window1Start = 0.3;
        classifier.param.window1End = 0.8;
        classifier.param.window1NumTimeSlice = 5;
        
        classifier.param.window2Start = -0.2;
        classifier.param.window2End = 0.8;
        classifier.param.window2NumTimeSlice = 20;
        classifier.param.window2Baseline = 0.3;
        
        classifier.lpf = 10.667;
        classifier.hpf = 0.1;
        classifier.filterOrder = 4;
        
        classifier.param.decimation = 1;
        
        classifier.param.decimation1 = 1;
        classifier.param.decimation2 = 1;
        
        classifier.param.epoch = [-500 1600];
        classifier.param.removeBaseline = 0;
        classifier.param.step = 1;
    case 'XDBLDA'
        classifier.train = @TrainXDBLDA;
        classifier.test = @TestXDBLDA;
        classifier.preProcess = @PreProcessXDBLDA;
        
        classifier.param.decimation1 = 2;
        classifier.param.decimation2 = 2;
        classifier.param.decimation = 4;
        classifier.param.nfilters = 8;
        
        classifier.param.epoch(1) = 0;
        
        
        classifier.lpf = 10.667;
        classifier.hpf = 0.1;
        classifier.filterOrder = 4;
        
        classifier.param.groupOrder = 2;
        
    case 'CSP'
        classifier.train = @TrainCSP;
        classifier.test = @TestCSP;
        classifier.preProcess = @PreProcessCSP;
        
        classifier.param.decimation1 = 4;
        classifier.param.decimation2 = 4;
        classifier.param.decimation = 16;
        classifier.param.nfilters = 8;
        
        classifier.param.epoch(1) = 0;
        
        
        classifier.lpf = 10.667;
        classifier.hpf = 0.1;
        classifier.filterOrder = 4;
        
        classifier.param.groupOrder = 2;
        
    case 'CTP'
        classifier.train = @TrainCTP;
        classifier.test = @TestCTP;
        classifier.preProcess = @PreProcessCTP;
        
        classifier.param.decimation1 = 4;
        classifier.param.decimation2 = 4;
        classifier.param.decimation = 16;
        classifier.param.nfilters = 8;
        
        classifier.param.epoch(1) = 0;
        
        
        classifier.lpf = 10.667;
        classifier.hpf = 0.1;
        classifier.filterOrder = 4;
        
        classifier.param.groupOrder = 2;
        
        case 'BCSP'
        classifier.train = @TrainXDBLDA;
        classifier.test = @TestXDBLDA;
        classifier.preProcess = @PreProcessBCSP;
        
        classifier.param.decimation1 = 2;
        classifier.param.decimation2 = 1;
        classifier.param.decimation = 2;
        classifier.param.nfilters = 8;
        
        classifier.param.g = 4;
        classifier.param.h = 2;
        classifier.param.numIterations = 10;
        
        classifier.param.epoch(1) = 0;
        
        
        classifier.lpf = 10.667;
        classifier.hpf = 0.1;
        classifier.filterOrder = 4;
        
        classifier.param.groupOrder = 2;
        
end
