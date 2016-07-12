%% exp name
expName(1).name = 'Experiment X6 Speed Control';
expName(2).name = 'Experiment X2 Traffic Complexity';
expName(3).name = 'Experiment XB Baseline Driving';
expName(4).name = 'Experiment XC Calibration Driving';
expName(5).name = 'X3 Baseline Guard Duty';
expName(6).name = 'X4 Advanced Guard Duty';
expName(7).name = 'X2 RSVP Expertise';
expName(8).name = 'X1 Baseline RSVP';
expName(9).name = 'Experiment X7 Auditory Cueing';
expName(10).name = 'Experiment X8 Mind Wandering';

%% chn size
expName(1).nbchan = 64;
expName(2).nbchan = 64;
expName(3).nbchan = 64;
expName(4).nbchan = 64;
expName(5).nbchan = 256;
expName(6).nbchan = 256;
expName(7).nbchan = 256;
expName(8).nbchan = 256;
expName(9).nbchan = 64;
expName(10).nbchan = 64;

%% lbl behavior
expName(1).label(1).behavior = 'On task fatigue: high/medium/low';
expName(2).label(1).behavior = 'On task fatigue: high/medium/low';
expName(3).label(1).behavior = 'On task fatigue: high/medium/low';
expName(4).label(1).behavior = 'On task fatigue: high/medium/low';

expName(5).label(1).behavior = 'Detection of non-time-locked target/non-target image ID';
expName(6).label(1).behavior = 'Detection of non-time-locked target/non-target image ID';
expName(7).label(1).behavior = 'Detection of time-locked target/non-target image';
expName(8).label(1).behavior = 'Detection of time-locked target/non-target image';

expName(5).label(2).behavior = 'Hit/miss detection of image ID';
expName(6).label(2).behavior = 'Hit/miss detection of image ID';
expName(7).label(2).behavior = 'Hit/miss detection of image';
expName(8).label(2).behavior = 'Hit/miss detection of image';

expName(5).label(3).behavior = 'Learning fatigue for image ID recognition: high/medium/low';
expName(6).label(3).behavior = 'Learning fatigue for image ID recognition: high/medium/low';
expName(7).label(3).behavior = 'Learning fatigue for image recognition: high/medium/low';
expName(8).label(3).behavior = 'Learning fatigue for image recognition: high/medium/low';

expName(9).label(1).behavior = '';
expName(10).label(1).behavior = '';

%% lbl metric.event{n}  
% -- replace with correct event tags
% -- event{1} is the event that will extract epoch based on its occur time
% -- event{2} is the event that will extract epoch based on some threshold
expName(1).label(1).metric.event{1} = {'Perturbation Onset'};
expName(2).label(1).metric.event{1} = {'Perturbation Onset'};
expName(3).label(1).metric.event{1} = {'Perturbation Onset'};
expName(4).label(1).metric.event{1} = {'Perturbation Onset'};

expName(1).label(1).metric.event{2} = {'RT'};
expName(2).label(1).metric.event{2} = {'RT'};
expName(3).label(1).metric.event{2} = {'RT'};
expName(4).label(1).metric.event{2} = {'RT'};
%==========================================================================
expName(5).label(1).metric.event{1} = {'Image ID onset'};
expName(6).label(1).metric.event{1} = {'Image ID onset'};
expName(7).label(1).metric.event{1} = {'Image onset'};
expName(8).label(1).metric.event{1} = {'Image onset'};

expName(5).label(1).metric.event{2} = {'Allow press', 'Deny press'};
expName(6).label(1).metric.event{2} = {'Allow press', 'Deny press'};
expName(7).label(1).metric.event{2} = {'left button press', 'right button press'};
expName(8).label(1).metric.event{2} = {'left button press', 'right button press'};
%==========================================================================
expName(5).label(2).metric.event{1} = {''};
expName(6).label(2).metric.event{1} = {''};
expName(7).label(2).metric.event{1} = {''};
expName(8).label(2).metric.event{1} = {''};

expName(5).label(2).metric.event{2} = {''};
expName(6).label(2).metric.event{2} = {''};
expName(7).label(2).metric.event{2} = {''};
expName(8).label(2).metric.event{2} = {''};
%==========================================================================
expName(5).label(3).metric.event{1} = {'2110', '2120'};
expName(6).label(3).metric.event{1} = {'2110', '2120'};
expName(7).label(3).metric.event{1} = {'1311', '1321'}; % 3	Present Image	1	Target	1	Onset;
expName(8).label(3).metric.event{1} = {'1311', '1321'}; %                   2	Non-target	2	Offset;

expName(5).label(3).metric.event{2} = {'1311', '1321', '1331', '1341', '1351', '1361', '1312', '1322', '1332', '1342', '1352', '1362'};
expName(6).label(3).metric.event{2} = {'1311', '1321', '1331', '1341', '1351', '1361', '1312', '1322', '1332', '1342', '1352', '1362'};
expName(7).label(3).metric.event{2} = {'2111', '2121'}; 
expName(8).label(3).metric.event{2} = {'2111', '2121'}; 
%==========================================================================
expName(9).label(1).metric.event{1} = {''};
expName(10).label(1).metric.event{1} = {''};

expName(9).label(1).metric.event{2} = {''};
expName(10).label(1).metric.event{2} = {''};

%% lbl etime -- this must be a range
expName(1).label(1).etime = [-1, 0];
expName(2).label(1).etime = [-1, 0];
expName(3).label(1).etime = [-1, 0];
expName(4).label(1).etime = [-1, 0];

expName(5).label(1).etime = [-5, 0];
expName(6).label(1).etime = [-5, 0];
expName(7).label(1).etime = [0, 1];
expName(8).label(1).etime = [0, 1];

expName(5).label(2).etime = [];
expName(6).label(2).etime = [];
expName(7).label(2).etime = [];
expName(8).label(2).etime = [];

expName(5).label(3).etime = [];
expName(6).label(3).etime = [];
expName(7).label(3).etime = [];
expName(8).label(3).etime = [];

expName(9).label(1).etime = [];
expName(10).label(1).etime = [];
