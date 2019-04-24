function collectionName = getId(obj)
% GETID Gets the name of the resource
% Returns the collection Id as a character vector

% Copyright 2019 The MathWorks, Inc.

collectionName = char(obj.Handle.getId());

end
