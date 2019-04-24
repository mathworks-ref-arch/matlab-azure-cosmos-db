function result = deleteAttachment(obj, attachmentLink, options)
% DELETEATTACHMENT Deletes an attachment
% Returns a ResourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(attachmentLink)
    write(logObj,'error','Expected attachmentLink of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.deleteAttachment(attachmentLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);


end %function
