function setSlug(obj, slug)
% SETSLUG Sets the HTTP Slug header value
% slug should be of type character vector

% Copyright 2019 The MathWorks, Inc.

if ~ischar(slug)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected slug as a character vector');
end

obj.Handle.setSlug(slug);

end
