% sample code for running XDAWN + Bayesian LDA on RSVP data

addpath([pwd '/blda']);
addpath([pwd '/Utilities/']);

% load in an RSVP dataset
EEG = pop_loadset('S09_baseline_central_periph_concat_filt0.1_55_avgearsref_interp_clean_ica_blinksgone.set');

% creates the classifier structure. The inputs are:
% 1st: A string label for the classifier type. Only XDBLDA available
% 2nd: Sampling rate, taken from EEG.srate
% 3rd: Epoch size for analysis. [0, 1000] milliseconds
% 4th: Channel index to use
% 5th: Class A event codes, given as numeric
% 6th: Class B event codes, given as numeric. 
classifier = CreateClassifierStruct('XDBLDA', EEG.srate, [0 1000], 1:66, [1;2;4;5;129;130;132;133], [3;6;131;134]);
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

% assume we will take the first 20% of the trials to train the spatial
% filter
allEvents = union(EventsA.index, EventsB.index);

% find the event number corresponding to 20%
temp1 = floor(.2*length(allEvents));
[~,classifier.trainWindowA] = intersect(EventsA.index, allEvents(1:temp1));
[~,classifier.trainWindowB] = intersect(EventsB.index, allEvents(1:temp1));

% run the preprocess script to get the spatially filtered data. 
[dataClassA, dataClassB, classifier]= PreProcessXDBLDA(EEG.data, classifier);

% train XDBLDA, on first 200 epochs of ClassA (Targets) and 1000 from
% ClassB (Nontargets)
[weights, performance] = TrainXDBLDA(dataClassA(:,:,1:200), dataClassB(:,:,1:1000), classifier);

% test XDBLDA on held out trials
for i = 201 : size(dataClassA, 3)
    [XDBLDAscoreA(i), XDBLDApredictionsA(i)] = TestXDBLDA(dataClassA(:,:,i), classifier, weights);
end

for i = 1001 : size(dataClassB, 3)
    [XDBLDAscoreB(i), XDBLDApredictionsB(i)] = TestXDBLDA(dataClassB(:,:,i), classifier, weights);
end

% calculate Az
rocarea([XDBLDAscoreA(201:end)'; XDBLDAscoreB(1001:end)'], [ones(length(XDBLDAscoreA(201:end)),1); zeros(length(XDBLDAscoreB(1001:end)),1)])
