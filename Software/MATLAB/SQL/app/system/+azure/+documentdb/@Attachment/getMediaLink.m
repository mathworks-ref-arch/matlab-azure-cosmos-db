function result = getMediaLink(obj)
% GETMEDIALINK Gets the media link associated with the attachment content
% A character vector is returned.

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getMediaLink());

end
