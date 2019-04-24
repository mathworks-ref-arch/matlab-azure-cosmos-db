function result = readStoredProcedures(obj, collectionLink, options)
% READSTOREDPROCEDURES Reads all stored procedures in a document collection link
% Returns a FeedResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','collectionLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.FeedOptions')
    write(logObj,'error','options argument not of type azure.documentdb.FeedOptions');
end

resultJ = obj.Handle.readStoredProcedures(collectionLink, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end %function
