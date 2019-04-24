function setScriptLoggingEnabled(obj, scriptLoggingEnabled)
% SETSCRIPTLOGGINGENABLED Enables stored procedure logging
% Sets whether Javascript stored procedure logging is enabled for the current
% request in or not.

% Copyright 2019 The MathWorks, Inc.

if ~islogical(scriptLoggingEnabled)
    logObj = Logger.getLogger();
    write(logObj,'error','scriptLoggingEnabled argument not of type logical');
else
    obj.Handle.setScriptLoggingEnabled(scriptLoggingEnabled);
end

end
