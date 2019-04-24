function result = readCollections(obj, databaseLink, options)
% READCOLLECTIONS Reads all document collections in a database
%
% Example:
% TODO

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','databaseLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.FeedOptions')
    write(logObj,'error','options argument not of type azure.documentdb.FeedOptions');
end

resultJ = obj.Handle.readCollections(databaseLink, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end %function
