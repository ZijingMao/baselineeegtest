function [ dataClassA, dataClassB, dataClassC ] = ...
    get_dataClass( i, valencdIdx , rangeA, rangeB, rangeC, flag)
%GETDATACLASS Summary of this function goes here

data = [];
labels = [];

subjectIDStr=sprintf('%2.2d',i);

load(['/home/zijing.mao/DEAPdataset/EEGEmotionExperiment/Data/s' subjectIDStr '.mat']);

l = labels(:, valencdIdx);
classANum = find(l>rangeA(1) & l<rangeA(2));
classBNum = find(l>rangeB(1) & l<rangeB(2));
classCNum = find(l>rangeC(1) & l<rangeC(2));

if flag
    balanceSize = min([length(classANum), length(classBNum), length(classCNum)]);

    classANum = classANum(randperm(length(classANum)));
    classBNum = classBNum(randperm(length(classBNum)));
    classCNum = classCNum(randperm(length(classCNum)));

    classANum = classANum(1:balanceSize);
    classBNum = classBNum(1:balanceSize);
    classCNum = classCNum(1:balanceSize);
end

dataClassA = data(classANum, :,:);
dataClassB = data(classBNum, :,:);
dataClassC = data(classCNum, :,:);

end

