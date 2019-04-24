function setId(obj, dbName)
% SETID Sets the name of the resource
%
% Example:
%   database = azure.documentdb.Database();
%   database.setId('mydbname');
%   docClient.createDatabase(database);

% Copyright 2019 The MathWorks, Inc.

if ~ischar(dbName)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name as a character vector');
end

obj.Handle.setId(dbName);

end
