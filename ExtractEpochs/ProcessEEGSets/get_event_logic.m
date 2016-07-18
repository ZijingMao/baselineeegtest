function [ non_zero_event ] = get_event_logic( eventtype, event )

mattype_logic = zeros(1, length(eventtype));
for epoch_event_idx = 1:length(event)
    [ mattype_tmp ] = event_strcmp( eventtype, event{epoch_event_idx} );
    mattype_logic = mattype_logic | mattype_tmp;
end
non_zero_event = find(mattype_logic);

end

