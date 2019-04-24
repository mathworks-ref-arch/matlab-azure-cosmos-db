function result = queryOffers(obj, query, options)
% QUERYOFFERS Query for offers in a database
% Returns a FeedResponse.
%
% Example:
%    queryStr = ['SELECT * FROM c where c.offerResourceId = ''', documentCollection.getResourceId(),''''];
%    feedOptions = azure.documentdb.FeedOptions();
%    offersFeedResponse = docClient.queryOffers(queryStr, feedOptions);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

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

resultJ = obj.Handle.queryOffers(queryJ, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end
