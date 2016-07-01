function [dataClassA, dataClassB, classifier, ReRef]= PreProcessXDBLDA(data, classifier)

EventsA = classifier.EventsA;
EventsB = classifier.EventsB;




[bLow,aLow] = butter(classifier.filterOrder,classifier.lpf/(classifier.param.sampleRate/2),'low');
[bHigh,aHigh] = butter(classifier.filterOrder,classifier.hpf/((classifier.param.sampleRate/classifier.param.decimation)/2),'high'); % after decimation

% transpose to get time x electrode
Signal_in=double(data)';



% take mean of each electrode
Signal_mean=mean(Signal_in,1);

Signal_out=[];
%keyboard;
for i=1:size(Signal_in, 2);
    
    % baseline correct each electrode
    Signal_in(:,i)=Signal_in(:,i)-Signal_mean(1,i);
    
%     if verbose
%         fprintf(['\t_ Band pass filtering and decimating sensor : ' num2str(i)  '\n']);
%         tic;
%     end
    
    % Low pass filtering
    Signal_in(:,i) = filter(bLow,aLow, Signal_in(:,i), [], 1);
    Signal_in(:,i) = flipdim(Signal_in(:,i), 1);
    Signal_in(:,i) = filter(bLow,aLow, Signal_in(:,i), [], 1);
    Signal_in(:,i) = flipdim(Signal_in(:,i), 1);
    
%     if verbose
%         fprintf(['\t_ Decimation \n']);
%         tic;
%     end
%     
    % Decimation (douvle decimation when the factor is too high)
    Signal_tmp=decimate(double(Signal_in(:,i)),classifier.param.decimation1);
    Signal_out(:,i)=decimate(double(Signal_tmp),classifier.param.decimation2);
    
 
    
    % High pass filtering
    Signal_out(:,i) = filter(bHigh,aHigh, Signal_out(:,i), [], 1);
    Signal_out(:,i) = flipdim(Signal_out(:,i), 1);
    Signal_out(:,i) = filter(bHigh,aHigh, Signal_out(:,i), [], 1);
    Signal_out(:,i) = flipdim(Signal_out(:,i), 1);
    
end




% calculate spatial filter based only on training window
[nSamples,nSensors]=size(Signal_out);

% if classifier.useNewSpatialFilter
    EventsAll.index = union(EventsA.index(classifier.trainWindowA), EventsB.index(classifier.trainWindowB));
    epochLength = 1;
    blockLengthSamples = floor(epochLength * classifier.param.sampleRate / classifier.param.decimation);
    
    
    
    
    % % create the index structure that contains indcies to all classA stimuli in
    % % element 1, and indicies to all stimuli in element 2.
    index(1).indexStimulus = int32(EventsA.index(classifier.trainWindowA)/ classifier.param.decimation);
    index(2).indexStimulus = int32(EventsAll.index / classifier.param.decimation);
    index(1).blockLength = (blockLengthSamples);
    index(2).blockLength = (blockLengthSamples);
    
    
    % calculate the spatial filter
    if isfield(classifier.param, 'spatialFilter')
        result.enhancedResponse.spatialFilter = classifier.param.spatialFilter;
        
    else
        [result.enhancedResponse, DTarget, D] = mxdawn(Signal_out,index,0);
        classifier.param.spatialFilter = result.enhancedResponse.spatialFilter;
    end
    
% else
%    
%     result.enhancedResponse.spatialFilter = classifier.XDBLDAFilter;
%       epochLength = 1;
%     blockLengthSamples = floor(epochLength * classifier.param.sampleRate / classifier.param.decimation);
%     index(1).blockLength = (blockLengthSamples);
%     index(2).blockLength = (blockLengthSamples);
% end

% apply the spatial filter
data = Signal_out * result.enhancedResponse.spatialFilter;


% EventsAll.index = union(EventsA.index, EventsB.index) / classifier.param.decimation;

% zero pad the data if necessary
data(nSamples+1:ceil(max(EventsAll.index)+index(1).blockLength),:)=0;
data = data';



dataClassA = ExtractEpochs(data, floor(EventsA.index / classifier.param.decimation), classifier.param.epoch, classifier.param.sampleRate / classifier.param.decimation);
dataClassB = ExtractEpochs(data, floor(EventsB.index/ classifier.param.decimation), classifier.param.epoch, classifier.param.sampleRate / classifier.param.decimation);




% save the spatial fitler to the classifier struct
ReRef = result.enhancedResponse.spatialFilter;

