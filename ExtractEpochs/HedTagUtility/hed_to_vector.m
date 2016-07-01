function [hedVectors, hedTags] = hed_to_vector(inputHEDStringArray, onlyKeepUsedTags,  importantTags)
% [hedVector hedTag] = hed_to_vector(inputTag, removeUnused,  importantTags)
% Converts HED strings to numerical vectors.
%   Focuses on the most important HED tags.
%
% Inputs:
%
%   inputHEDStringArray a N x 1 cell array of HED strings
%   onlyKeepUsedTags    a logical variable indicating if only tags that were at
%                       least present once should be kep and the dimensions
%                       of hedVector that are always zero should be removed. 
%   importantTags       a cell array containing HED tags that are 'important'  
%                       and will be considered when creating the output
%                       vector. If no value is presented a preset is used.
% Outputs:
%   hedVectors          an M x N matrix with ones at places associated with
%                       important tags. If onlyKeepUsedTags is set to true
%                       all dimensions corresponding to 'important tags'
%                       that never existed in inputTag are removed.
%   hedTags             tags associated with dimentions of the output 
%                       hedVector variable.



% need to map 'Participant\Effect\Cognitive\Non-target' to 'Participant\Effect\Cognitive\Expected\Non-target'
% need to map 'Action\Control vehicle\Drive\Correct' to 'Action\Type\Control vehicle\Drive\Correct'
originalinputHEDStringArray = inputHEDStringArray(:)';
inputHEDStringArray = strrep(lower(originalinputHEDStringArray), '\', '/'); % turn to lowercase
inputHEDStringArray = strrep(inputHEDStringArray, lower('Participant/Effect/Cognitive/Non-target'), lower('Participant/Effect/Cognitive/Expected/Non-target'));
inputHEDStringArray = strrep(inputHEDStringArray, lower('Action/Type/'), lower('Action/'));

if nargin < 2
    onlyKeepUsedTags = true;
end

if nargin < 3
    importantTags = {'Event/Category/Participant response', 'Attribute/Direction/Left', 'Attribute/Direction/Right'...
        'Event/Category/Experimental stimulus', 'Event/Category/Experimental stimulus/Instruction/Attend', ...
        'Event/Category/Experimental stimulus/Instruction/Fixate', 'Event/Category/Experimental stimulus/Instruction/Recall', ...
        'Event/Category/Experimental stimulus/Instruction/Generate', 'Event/Category/Experimental stimulus/Instruction/Repeat', ...
        'Event/Category/Experimental stimulus/Instruction/Imagine', 'Event/Category/Experimental stimulus/Instruction/Rest', ...
        'Event/Category/Experimental stimulus/Instruction/Count', 'Event/Category/Experimental stimulus/Instruction/Walk', ...
        'Event/Category/Experimental stimulus/Instruction/Move', 'Event/Category/Experimental stimulus/Instruction/Speak', ...
        'Event/Category/Experimental stimulus/Instruction/Detect', 'Event/Category/Experimental stimulus/Instruction/Name', ...
        'Event/Category/Experimental stimulus/Instruction/Track', 'Event/Category/Experimental stimulus/Instruction/Encode', ...
        'Participant/Effect/Cognitive/Reward', 'Participant/Effect/Cognitive/Penalty', 'Participant/Effect/Cognitive/Error',...
        'Participant/Effect/Cognitive/Oddball', 'Participant/Effect/Cognitive/Target', 'Participant/Effect/Cognitive/Expected', ...
        'Participant/Effect/Cognitive/Expected/Non-Target', ...
        'Action/Control vehicle/Drive/Correct', 'Action/Button press', 'Participant/Effect/Visual', 'Participant/Effect/Auditory', ...
        'Attribute/Object control/Perturb', 'Attribute/Object control/Correct position'};
end;

hedVectors = zeros(length(importantTags), length(inputHEDStringArray));

% make all lower to simplify comparison
inputHEDStringArray = lower(inputHEDStringArray);
lowercaseimportantTags = lower(importantTags);

% make all slashes forward
lowercaseimportantTags = strrep(lowercaseimportantTags, '\', '/');


for i=1:length(lowercaseimportantTags)
    % make each cell to 1 element
    % cellElementAdd = @(str) sum(cell2mat(str));
    
    cellforTag = strfind(inputHEDStringArray, lowercaseimportantTags{i});
    cellforTag(~cellfun(@isempty, cellforTag)) = {1};
    cellforTag(cellfun(@isempty, cellforTag)) = {0};
    
    % exclude if it has offset
    cellforOffsetTag = strfind(inputHEDStringArray, 'attribute/offset');
    cellforOffsetTag(~cellfun(@isempty, cellforOffsetTag)) = {1};
    cellforOffsetTag(cellfun(@isempty, cellforOffsetTag)) = {0};
    
    % include if it has onset
    cellforOnsetTag = strfind(inputHEDStringArray, 'attribute/onset');
    cellforOnsetTag(~cellfun(@isempty, cellforOnsetTag)) = {1};
    cellforOnsetTag(cellfun(@isempty, cellforOnsetTag)) = {0};
    
    matforOffsetTag = cell2mat(cellforOffsetTag);
    matforOnsetTag = cell2mat(cellforOnsetTag);
    
    hedVectors(i,:) = cell2mat(cellforTag) & ...
                        (matforOnsetTag | ~matforOffsetTag);
end;

if onlyKeepUsedTags
    id = any(hedVectors,2);
    % need to record the index for important tags
    hedVectors = hedVectors(id,:);    
    hedTags = importantTags(id);
else
    hedTags = importantTags;
end

end

