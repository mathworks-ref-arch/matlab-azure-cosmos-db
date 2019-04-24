function setBody(obj, body)
% SETBODY Set the body of the stored procedure
% Body argument should be a character vector

% Copyright 2019 The MathWorks, Inc.

if ~ischar(body)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected body as a character vector');
end

obj.Handle.setBody(body);

end
