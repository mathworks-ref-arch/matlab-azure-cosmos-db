function result = readAttachments(obj, documentLink, options)
% READATTACHMENTS Reads all attachments in a document
% Returns a FeedResponse.
%
% Example:
%    feedOptions = azure.documentdb.FeedOptions();
%    readResponses = docClient.readAttachments(documentLink, feedOptions);
%    responseCellArray = readResponses.getQueryCellArray();

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(documentLink)
    write(logObj,'error','documentLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.FeedOptions')
    write(logObj,'error','options argument not of type azure.documentdb.FeedOptions');
end

resultJ = obj.Handle.readAttachments(documentLink, options.Handle);
result = azure.documentdb.FeedResponse(resultJ);

end %function
