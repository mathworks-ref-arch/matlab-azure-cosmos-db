function setBody(obj, body)
% SETBODY Set the body of the trigger
% Body should be a character vector, it should not be JSON encoded

% Copyright 2019 The MathWorks, Inc.


if ~ischar(body)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected body as a character vector');
end

obj.Handle.setBody(body);

end
