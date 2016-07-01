
addpath(genpath(pwd));

load('X2RSVP.mat');
x = Inputs;
y = Labels;

stepSize = 2;
logScale = true;

%% for subject 1, run 10 times for testing
subID = 1;
x = Inputs{subID};
y = Labels{subID};
auc = cell(1,5); aucX = cell(1,5);
parfor fold = 1:5
    rng(fold);
    [auc{fold}, aucX{fold}] = generate_learn_curve(x, y, stepSize, logScale);
end
save(['./Results/SampleSize' num2str(subID) '.mat'], 'auc', 'aucX');

%% for each subject, run the function to generate learning curve
c = clock;
mySeed = sum(fix(c));
rng(mySeed);
parfor subID = 1 : 10
    [auc{subID}, aucX{subID}] = generate_learn_curve(x{subID}, y{subID}, stepSize, logScale);
end

save(['./Results/SampleSize' num2str(mySeed) '.mat'], 'auc', 'aucX');