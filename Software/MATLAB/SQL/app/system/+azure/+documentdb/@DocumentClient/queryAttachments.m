function result = queryAttachments(obj, documentLink, query, options)
% QUERYATTACHMENT Query for attachments
% Returns a FeedResponse.
%
% Example:
%    feedResponse = docClient.queryAttachments(documentLink, 'SELECT * from r', feedOptions);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(documentLink)
    write(logObj,'error','documentLink argument not of type character vector');
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

resultJ = obj.Handle.queryAttachments(documentLink, queryJ, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end %function
