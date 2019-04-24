function setId(obj, name)
% SETID Sets the name of the resource
%
% Example:
%   attachment2.setId('myAttachmentId');

% Copyright 2019 The MathWorks, Inc.

if ~ischar(name)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name as a character vector');
end

obj.Handle.setId(name);

end
