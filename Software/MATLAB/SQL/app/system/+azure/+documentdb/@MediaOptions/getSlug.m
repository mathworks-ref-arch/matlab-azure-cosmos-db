function result = getSlug(obj)
% GETSLUG Gets the HTTP Slug header value
% Returns a character vector

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getSlug());

end
