function setId(obj, udfName)
% SETID Sets the name of the resource
%
% Example:
%    myUDF = azure.documentdb.UserDefinedFunction();
%    myUDF.setId('myUDFName');

% Copyright 2019 The MathWorks, Inc.

if ~ischar(udfName)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected udfName as a character vector');
end

obj.Handle.setId(udfName);

end
