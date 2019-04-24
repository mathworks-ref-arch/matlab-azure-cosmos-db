function result = readAttachment(obj, attachmentLink, options)
% READATTACHMENT Reads an attachment
% Returns a ReourceResponse.
%
% Example:
%    attachmentLink = attachmentResource.getSelfLink();
%    readResponse = docClient.readAttachment(attachmentLink, options);
%    readAttachment = readResponse.getResource();

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(attachmentLink)
    write(logObj,'error','attachmentLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.readAttachment(attachmentLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
