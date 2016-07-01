function [dataClassA, dataClassB, classifier]= PreProcessExtractEpochs(data, classifier)

EventsA = classifier.TRG;
EventsB = classifier.NTG;

% 
% 
% [bLow,aLow] = butter(classifier.filterOrder,classifier.lpf/(classifier.param.sampleRate/2),'low');
% [bHigh,aHigh] = butter(classifier.filterOrder,classifier.hpf/((classifier.param.sampleRate/classifier.param.decimation)/2),'high'); % after decimation
% 
% % transpose to get time x electrode
% Signal_in=double(data)';
% 
% 
% % take mean of each electrode
% Signal_mean=mean(Signal_in,1);
% 
% Signal_out=[];
% %keyboard;
% for i=1:size(Signal_in, 2);
%     
%     % baseline correct each electrode
%     Signal_in(:,i)=Signal_in(:,i)-Signal_mean(1,i);
%     
% %     if verbose
% %         fprintf(['\t_ Band pass filtering and decimating sensor : ' num2str(i)  '\n']);
% %         tic;
% %     end
%     
%     % Low pass filtering
%     Signal_in(:,i) = filter(bLow,aLow, Signal_in(:,i), [], 1);
%     Signal_in(:,i) = flipdim(Signal_in(:,i), 1);
%     Signal_in(:,i) = filter(bLow,aLow, Signal_in(:,i), [], 1);
%     Signal_in(:,i) = flipdim(Signal_in(:,i), 1);
%     
% %     if verbose
% %         fprintf(['\t_ Decimation \n']);
% %         tic;
% %     end
% %     
%     % Decimation (douvle decimation when the factor is too high)
%     Signal_tmp=decimate(double(Signal_in(:,i)),classifier.param.decimation1);
%     Signal_out(:,i)=decimate(double(Signal_tmp),classifier.param.decimation2);
%     
%  
%     
%     % High pass filtering
%     Signal_out(:,i) = filter(bHigh,aHigh, Signal_out(:,i), [], 1);
%     Signal_out(:,i) = flipdim(Signal_out(:,i), 1);
%     Signal_out(:,i) = filter(bHigh,aHigh, Signal_out(:,i), [], 1);
%     Signal_out(:,i) = flipdim(Signal_out(:,i), 1);
%     
% end
% 
% 
% data = Signal_out';


% epoch
dataClassA = ExtractEpochs(data, EventsA.index, classifier.param.epoch, classifier.param.sampleRate);
dataClassB = ExtractEpochs(data, EventsB.index, classifier.param.epoch, classifier.param.sampleRate);

% remove baseline
% if classifier.param.removeBaseline
%     dataClassA = removeBaseline(dataClassA, abs(classifier.param.epoch(1))/1000, classifier.param.sampleRate);
%     dataClassB = removeBaseline(dataClassB, abs(classifier.param.epoch(1))/1000, classifier.param.sampleRate);
% %      dataClassA = removeBaseline(dataClassA, 1200, classifier.param.sampleRate);
% %      dataClassB = removeBaseline(dataClassB, 1200, classifier.param.sampleRate);
% 
% end
% 
% 
