function setContentType(obj, contentType)
% SETCONTENTTYPE Sets the content MIME type of the attachment content
%
% Example:
%   myAttachment.setContentType('text/plain');

% Copyright 2019 The MathWorks, Inc.

if ~ischar(contentType)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected contentType as a character vector');
end

obj.Handle.setContentType(contentType);

end
