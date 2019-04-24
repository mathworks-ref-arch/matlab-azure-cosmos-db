function result = getScriptLog(obj)
% GETSCRIPTLOG Gets the output from stored procedure console.log() statements
% Returns a character vector.

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getScriptLog());

end
