function [boundaryIndices boundaryLatencies] = ExtractBoundaryEvents(EEG)

boundaryIndices = [];
boundaryLatencies = 0;
for i = 1:length(EEG.event)
    if (strcmp(EEG.event(i).type, 'boundary'))
        boundaryIndices = [boundaryIndices; i];
    end
end

for i = 1:length(boundaryIndices)
    boundaryLatencies(i) = EEG.event(boundaryIndices(i)).latency;
end