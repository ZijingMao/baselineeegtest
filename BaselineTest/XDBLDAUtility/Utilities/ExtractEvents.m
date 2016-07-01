function [Events] = ExtractEvents(EEG, codes, decimation, epoch)


% create a list of all events
Events.index=[];
Events.label=[];
Events.nb=size(EEG.event,2);
epochSamples = floor((epoch /1000) * EEG.srate);
[BoundaryIndices BoundaryLatencies] = ExtractBoundaryEvents(EEG);


for i=1:Events.nb
    if (EEG.event(i).latency + epochSamples(1) > 0) && (EEG.event(i).latency + epochSamples(2) < (EEG.pnts)) % enought data for epoch within bounds
       boundaryDist = EEG.event(i).latency - BoundaryLatencies;
       indA = find(boundaryDist > epochSamples(1));
       indB = find(boundaryDist < epochSamples(2));
       if (~isempty(intersect(indA, indB)))
           Events.index(i)=NaN;
           Events.label(i)=NaN;
       else
           Events.index(i)=EEG.event(i).latency/decimation;
           if (ischar(EEG.event(i).type))
                Events.label(i)=str2double(EEG.event(i).type);
           else
               Events.label(i)=EEG.event(i).type;
           end
       end
    else
           Events.index(i)=NaN;
           Events.label(i)=NaN;

    end
end



% extract the events that match the codes given
EventIndices = find(ismember(Events.label, codes));
Events.index = int32(Events.index(EventIndices));
Events.label = Events.label(EventIndices);