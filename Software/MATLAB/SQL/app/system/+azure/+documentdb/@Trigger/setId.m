function setId(obj, triggerName)
% SETID Sets the name of the resource
%
% Example:
%    trigger = azure.documentdb.Trigger();
%    trigger.setId('mytrigger');

% Copyright 2019 The MathWorks, Inc.

if ~ischar(triggerName)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected triggerName as a character vector');
end

obj.Handle.setId(triggerName);

end
