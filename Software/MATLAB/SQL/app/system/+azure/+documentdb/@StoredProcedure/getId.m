function procedureName = getId(obj)
% GETID Gets the name of the resource
% Returns the procedure Id as a character vector

% Copyright 2019 The MathWorks, Inc.

procedureName = char(obj.Handle.getId());

end
