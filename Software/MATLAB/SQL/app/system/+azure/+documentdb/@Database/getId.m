function dbName = getId(obj)
% GETID Gets the name of the resource
% Returns the database Id as a character vector

% Copyright 2019 The MathWorks, Inc.

dbName = char(obj.Handle.getId());

end
