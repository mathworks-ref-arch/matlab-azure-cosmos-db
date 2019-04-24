function result = getResourceId(obj)
% GETRESOURCEID Gets the name of the resource
% Returns a character vector.

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getResourceId());

end
