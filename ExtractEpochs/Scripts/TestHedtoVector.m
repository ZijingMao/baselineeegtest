
%% make sure the sizes of output variables are right
inputTag = {'Event/Category/Participant response',...
    'Participant/Effect/Cognitive/Expected/Non-Target, Attribute/Direction/Left'};

[hedVector, hedTag] = hed_to_vector(inputTag, true);

assert(isequal(size(hedVector), [4 2]));

%% make sure the sizes of output variables are right
inputTag = {'Event/Category/Participant response',...
    'Participant/Effect/Cognitive/Expected/Non-Target, Attribute/Direction/Left'}';

[hedVector, hedTag] = hed_to_vector(inputTag, true);

assert(isequal(size(hedVector), [4 2]));


%% make sure the content of hedVector is correct

inputTag = {'Event/Category/Participant response',...
    'Participant/Effect/Cognitive/Expected/Non-Target, Attribute/Direction/Left'};

[hedVector, hedTag] = hed_to_vector(inputTag, true);

expectedvalue = [
     1     0
     0     1
     0     1
     0     1];
 
assert(isequal(expectedvalue, hedVector));

%% make sure the content of hedTag is correct

inputTag = {'Event/Category/Participant response',...
    'Participant/Effect/Cognitive/Expected/Non-Target, Attribute/Direction/Left'};

[hedVector, hedTag] = hed_to_vector(inputTag, true);

expectedvalue = {
     'Event/Category/Participant response'
    'Attribute/Direction/Left'
    'Participant/Effect/Cognitive/Expected'
    'Participant/Effect/Cognitive/Expected/Non-Target'}';
 
assert(isequal(expectedvalue, hedTag));