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
temp1 = floor(.5*length(allEvents));

% find the indices to for 10-fold CV
indices = floor(linspace(0, length(allEvents), 11));
for i = 2 : 11
    index{i-1} = indices(i-1)+1:indices(i);
end

for KK = 1 : 10

[~,classifier.trainWindowA] = intersect(EventsA.index, allEvents(cell2mat(index(setdiff(1:10, KK)))));
[~,classifier.trainWindowB] = intersect(EventsB.index, allEvents(cell2mat(index(setdiff(1:10, KK)))));

% run the preprocess script to get the spatially filtered data. 
[dataClassA, dataClassB, classifier]= PreProcessXDBLDA(EEG.data, classifier);

% train XDBLDA, on first 200 epochs of ClassA (Targets) and 1000 from
% ClassB (Nontargets)
[weights, performance] = TrainXDBLDA(dataClassA(:,:,classifier.trainWindowA), dataClassB(:,:,classifier.trainWindowB), classifier);

% test XDBLDA on held out trials
for i = 1 : size(dataClassA, 3)
    [XDBLDAscoreA(i), XDBLDApredictionsA(i)] = TestXDBLDA(dataClassA(:,:,i), classifier, weights);
end

for i = 1 : size(dataClassB, 3)
    [XDBLDAscoreB(i), XDBLDApredictionsB(i)] = TestXDBLDA(dataClassB(:,:,i), classifier, weights);
end

% calculate Az on only the testing set
scores1 = [XDBLDAscoreA(setdiff(1:size(dataClassA, 3), classifier.trainWindowA))'; XDBLDAscoreB(setdiff(1:size(dataClassB, 3), classifier.trainWindowB))']';
labels1 = [ones(length(XDBLDAscoreA(setdiff(1:size(dataClassA, 3), classifier.trainWindowA))),1); zeros(length(XDBLDAscoreB(setdiff(1:size(dataClassB, 3), classifier.trainWindowB))),1)]';
temp = rocarea(scores1, labels1);
Az1(KK) = temp; clear temp;

end