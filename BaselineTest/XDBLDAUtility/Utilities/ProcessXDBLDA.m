function [XDBLDA, XDBLDApredictions] = ProcessXDBLDA(SourceData, TargetData, labels, options, t1, currIndex, XDBLDA)




data = [];
eventA = [];
eventB = [];
indA = find(t1);
for i =  1:length(indA)
    eventA(i).index = size(data, 2)+1;
    eventA(i).label = 1;
    data = [data SourceData.data(:, :, indA(i))];
    
end
indB = find(~t1);
for i =  1:length(indB)
    eventB(i).index = size(data, 2)+1;
    eventB(i).label = -1;
    data = [data SourceData.data(:, :, indB(i))];
    
end

options.EventsA = eventA;
options.EventsB = eventB;
options.decimation1 = 1;
options.decimation2 = 1;

[dataClassA, dataClassB, ReRef] = PreProcessXDBLDA(data, options);
options.nfilters = 8;
options.decimation = 1;

[XDBLDAweights, XDBLDAperformance] = TrainXDBLDA(dataClassB, dataClassA, options);

for i = 1 : length(TargetData.epoch)
    keyboard;
    [XDBLDAscore(i), XDBLDApredictions(i)] = TestXDBLDA(ReRef.param.spatialFilter*TargetData.data(:,:,i), options, XDBLDAweights);
end

XDBLDA.accuracy(currIndex) = sum(XDBLDApredictions == strcmp(labels, 'ntg'))/length(labels);
XDBLDA.AUC(currIndex) = rocarea(XDBLDAscore, strcmp(labels, 'ntg'));

index1 = strcmp(labels, 'trg');
index2 = strcmp(labels, 'ntg');

XDBLDA.target_accuracy(currIndex) = sum(XDBLDApredictions(index1) == 0)/sum(index1); 
XDBLDA.nontarget_accuracy(currIndex) = sum(XDBLDApredictions(index2) == 1)/sum(index2) ;