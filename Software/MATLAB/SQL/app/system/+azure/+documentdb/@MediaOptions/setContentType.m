function setContentType(obj, contentType)
% SETCONTENTTYPE Sets the HTTP ContentType header value
% contentType should be of type character vector

% Copyright 2019 The MathWorks, Inc.

if ~ischar(contentType)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected contentType as a character vector');
end

obj.Handle.setContentType(contentType);

end
