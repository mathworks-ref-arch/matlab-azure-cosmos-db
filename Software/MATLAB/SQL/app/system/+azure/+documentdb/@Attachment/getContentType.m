function result = getContentType(obj)
% GETCONTENTTYPE Gets the MIME content type of the attachment
% A character vector is returned.

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getContentType());

end
