function result = queryTriggers(obj, collectionLink, query, options)
% QUERYTRIGGERS Query for triggers
% Returns a FeedResponse.
%
% Example:
%   feedOptions = azure.documentdb.FeedOptions();
%   queryStr = ['SELECT * FROM r where r.id = ''', triggerId,''''];
%   queryResults = docClient.queryTriggers(collectionLink, queryStr, feedOptions);
%   responseCellArray = queryResults.getQueryCellArray();

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

resultJ = obj.Handle.queryTriggers(collectionLink, queryJ, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end %function
