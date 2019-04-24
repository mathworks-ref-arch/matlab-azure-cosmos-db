function result = getId(obj)
% GETID Gets the name of the resource
% A character vector is returned.

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getId());

end
