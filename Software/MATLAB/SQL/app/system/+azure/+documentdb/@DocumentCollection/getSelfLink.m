function collectionLink = getSelfLink(obj)
% GETSELFLINK Gets the link of the resource
% Returns the collectionLink as a character vector

% Copyright 2019 The MathWorks, Inc.

collectionLink = char(obj.Handle.getSelfLink());

end
