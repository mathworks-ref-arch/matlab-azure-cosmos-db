function triggerName = getId(obj)
% GETID Gets the name of the resource
% Returns the trigger Id as a character vector

% Copyright 2019 The MathWorks, Inc.

triggerName = char(obj.Handle.getId());

end
