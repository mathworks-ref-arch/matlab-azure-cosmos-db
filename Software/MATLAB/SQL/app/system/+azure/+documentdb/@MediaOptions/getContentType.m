function result = getContentType(obj)
% GETCONTENTTYPE Gets the HTTP ContentType header value
% Returns a character vector

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getContentType());

end
