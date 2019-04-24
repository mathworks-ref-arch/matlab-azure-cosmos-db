function link = getSelfLink(obj)
% GETSELFLINK Gets the link of the resource
% Returns the link as a character vector

% Copyright 2019 The MathWorks, Inc.

link = char(obj.Handle.getSelfLink());

end
