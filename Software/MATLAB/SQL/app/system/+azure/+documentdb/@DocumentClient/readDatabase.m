function result = readDatabase(obj, databaseLink, options)
% READDATABASE Reads a database
%
% Example:
%    options = azure.documentdb.RequestOptions();
%    databaseLink = ['/dbs/',database.getId()];
%    readResponse = docClient.readDatabase(databaseLink, options);
%    readResult = readResponse.getResource();

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(databaseLink)
    write(logObj,'error','databaseLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

% returns a ResourceResponse
resultJ = obj.Handle.readDatabase(databaseLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
