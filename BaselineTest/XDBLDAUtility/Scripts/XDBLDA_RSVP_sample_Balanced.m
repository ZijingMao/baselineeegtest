% sample code for running XDAWN + Bayesian LDA on RSVP data
clear;
addpath([pwd '/blda']);
addpath([pwd '/Utilities/']);

FilePath = ['/home/zijing.mao/XDBLDA/CT2WS/'];

filelist2cell = @(str) extractfield( (dir(str)), 'name' );
eeg_dataset_list = filelist2cell(FilePath)';
selectSetFile = @(str) str(1:( strfind(str, '.set')+3 ));
eeg_dataset_list = cellfun(@(str) selectSetFile(str), eeg_dataset_list, 'UniformOutput', false);
eeg_dataset_list_idx = find(~cellfun(@isempty,eeg_dataset_list));

Az = zeros(10, 15);

for idx = 2:2

FileName = eeg_dataset_list{eeg_dataset_list_idx(idx)};

% load EEG data
EEG = pop_loadset('filename',FileName,'filepath',FilePath);

% load in an RSVP dataset
% EEG = pop_loadset('S06_baseline_central_periph_concat_filt0.1_55_avgearsref_interp_clean_ica_blinksgone.set');

% creates the classifier structure. The inputs are:
% 1st: A string label for the classifier type. Only XDBLDA available
% 2nd: Sampling rate, taken from EEG.srate
% 3rd: Epoch size for analysis. [0, 1000] milliseconds
% 4th: Channel index to use
% 5th: Class A event codes, given as numeric
% 6th: Class B event codes, given as numeric. 
classifier = CreateClassifierStruct('XDBLDA', EEG.srate, [0 1000], 1:64, [1;2;4;5;129;130;132;133], [3;6;131;134]);
EventsA = ExtractEvents(EEG, [1;2;4;5;129;130;132;133], 1, classifier.param.epoch);
EventsB = ExtractEvents(EEG, [3;6;131;134], 1, classifier.param.epoch);

% leave this unchanged
classifier.EventsA = EventsA;
classifier.EventsB = EventsB;
classifier.sampleRate = EEG.srate;

% lowpass filter prior to xDAWN. 10.66Hz is default and has been shown to
% be very good for RSVP. 
classifier.lpf = 10.66;

% downsampling factors prior to xDAWN. Set .decimation so that the sampling
% rate is about 32Hz. Since the data is 512Hz this corresponds to a
% decimation of 16. Decimation1 and Decimation2 need to multiply to
% Decimation (here, 4x4 = 16). The exact meaning of these is a bit unclear,
% but it has something to do with forward and backward filtering
% (decimation1 and decimation2, respectively).
classifier.param.decimation1 = 4;
classifier.param.decimation2 = 4;
classifier.param.decimation = 16;

% set the number of spatial filters.. 8 is good for RSVP
classifier.param.nfilters = 8;
allEvents = union(EventsA.index, EventsB.index);


for KK = 1 : 10
    
    % set the seed for reproducing results
    rng(KK+100)
    % select at random 300 trials from target and nontarget classes
    t1 = randsample(1:length(EventsA.index), 300, 'false');
    
    rng(KK+101);
    t2 = randsample(1:length(EventsB.index), 300, 'false');
    
    [~,classifier.trainWindowA] = intersect(EventsA.index, EventsA.index(t1));
    [~,classifier.trainWindowB] = intersect(EventsB.index, EventsB.index(t2));
    
    % from here, select 225 of each for training xDAWN
    indexA = classifier.trainWindowA; indexB = classifier.trainWindowB;
    
    rng(KK + 103);
    classifier.trainWindowA = randsample(indexA, 225, 'false');
    
    rng(KK + 104);
    classifier.trainWindowB = randsample(indexB, 225, 'false');
    
    % run the preprocess script to get the spatially filtered data.
    [dataClassA, dataClassB, classifier]= PreProcessXDBLDA(EEG.data, classifier);
    
    % train XDBLDA
    [weights, performance] = TrainXDBLDA(dataClassA(:,:,classifier.trainWindowA), dataClassB(:,:,classifier.trainWindowB), classifier);
    
    % extract out the test set
    samplesA = setdiff(indexA, classifier.trainWindowA);
    samplesB = setdiff(indexB, classifier.trainWindowB);
    testSetA = dataClassA(:,:,samplesA(1:75));
    testSetB = dataClassB(:,:,samplesB(1:75));
    
    % test XDBLDA on held out trials
    for i = 1 : size(testSetA, 3)
        [XDBLDAscoreA(i), XDBLDApredictionsA(i)] = TestXDBLDA(testSetA(:,:,i), classifier, weights);
    end
    
    for i = 1 : size(testSetB, 3)
        [XDBLDAscoreB(i), XDBLDApredictionsB(i)] = TestXDBLDA(testSetB(:,:,i), classifier, weights);
    end
    
    % calculate Az on only the testing set
    scores1 = [XDBLDAscoreA'; XDBLDAscoreB']';
    labels1 = [ones(1, length(XDBLDAscoreA)) zeros(1, length(XDBLDAscoreB))];
    temp = rocarea(scores1, labels1);
    Az1(KK) = temp; clear temp;
    
end

Az(:, idx) = Az1;

end

