function close(obj)
% CLOSE Closes a GremlinClient instance
%
% Usage
%  
%   gclient.close()
%

%(Copyright 2020, The MathWorks, Inc.)

try
    obj.Handle.close();
catch exception
    write(logObj,'error',exception.message);
end
end
