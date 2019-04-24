function result = queryDocuments(obj, collectionLink, query, options)
% QUERYDOCUMENTS Query for documents in a document collection
% Returns a FeedResponse.
%
% Example:
%    feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
%    responseCellArray = feedResponse.getQueryCellArray();

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','collectionLink argument not of type character vector');
end

if ~ischar(query) && ~isa(query,'azure.documentdb.SqlQuerySpec')
    write(logObj,'error','query argument not of type character vector or azure.documentdb.SqlQuerySpec');
end

if ~isa(options, 'azure.documentdb.FeedOptions')
    write(logObj,'error','options argument not of type azure.documentdb.FeedOptions');
end

% pass the SqlQuerySpec Handle if query is not just a string
if ischar(query)
    queryJ = query;
else
    queryJ = query.Handle;
end

resultJ = obj.Handle.queryDocuments(collectionLink, queryJ, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end %function
