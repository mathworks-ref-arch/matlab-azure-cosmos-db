function setId(obj, name)
% SETID Sets the name of the resource
%
% Example:
%   mydocument = azure.documentdb.Document();
%   mydocument.setId('mydocname');
%   docClient.createDocument(mydocument);

% Copyright 2019 The MathWorks, Inc.

if ~ischar(name)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name as a character vector');
end

obj.Handle.setId(name);

end
