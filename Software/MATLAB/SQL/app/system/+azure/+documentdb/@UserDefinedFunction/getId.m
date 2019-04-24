function udfName = getId(obj)
% GETID Gets the name of the resource
% Returns the trigger Id as a character vector

% Copyright 2019 The MathWorks, Inc.

udfName = char(obj.Handle.getId());

end
