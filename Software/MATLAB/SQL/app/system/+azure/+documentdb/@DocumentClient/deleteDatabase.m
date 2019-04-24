function result = deleteDatabase(obj, databaseLink, options)
% DELETEDATABASE Deletes a database
% The database to delete is identified using a database link, this is the
% the Id proceeded by a path like string.
% Returns a ResourceResponse.
%
% Example:
%    options = azure.documentdb.RequestOptions();
%    databaseLink = ['/dbs/',database.getId()];
%    docClient.deleteDatabase(databaseLink, options)

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(databaseLink)
    write(logObj,'error','databaseLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.deleteDatabase(databaseLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
