function result = readDocuments(obj, collectionLink, options)
% READDOCUMENTS Reads all documents in a document collection.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','collectionLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.FeedOptions')
    write(logObj,'error','options argument not of type azure.documentdb.FeedOptions');
end

resultJ = obj.Handle.readDocuments(collectionLink, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end %function
