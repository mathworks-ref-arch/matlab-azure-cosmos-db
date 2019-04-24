function result = queryCollections(obj, databaseLink, query, options)
% QUERYCOLLECTION Query for document collections in a database
% Returns a FeedResponse
%
% Example:
%    feedOptions = azure.documentdb.FeedOptions();
%    queryStr = ['SELECT * FROM r where r.id = ''', collectionId,''''];
%    queryResults = docClient.queryCollections(databaseLink, queryStr, feedOptions);
%    responseCellArray = queryResults.getQueryCellArray();

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(databaseLink)
    write(logObj,'error','databaseLink argument not of type character vector');
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

resultJ = obj.Handle.queryCollections(databaseLink, queryJ, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end %function
