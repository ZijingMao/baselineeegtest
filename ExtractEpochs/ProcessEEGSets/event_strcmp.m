function [ mattype1 ] = event_strcmp( eventtype, epoch_event )

type1 = strfind(eventtype,epoch_event);
type1(~cellfun(@isempty, type1)) = {1};
type1(cellfun(@isempty, type1)) = {0};
mattype1 = cell2mat(type1);

end

