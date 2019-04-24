function setPath(obj, path)
% SETPATH Sets a path in an IncludedPath object

% Copyright 2019 The MathWorks, Inc.

if ~ischar(path)
    write(logObj,'error','path argument not of type character vector');
end

try
    obj.Handle.setPath(path);
catch ex
    disp(ex.message);
    me = MException('IncludedPath:setPathFailure', char(['setPath Error for: ' path]));
    throw(me);
end

end
