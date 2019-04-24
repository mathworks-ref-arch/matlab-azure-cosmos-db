function result = upsertAttachment(obj, documentLink, attachment, options)
% UPSERTATTACHMENT Upserts an attachment to a document
% Upsert provides an atomically safe alternative to a create or replace
% operation preceded by a read.
% Returns a ReourceResponse.
%
% Example:
%    documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
%    % create attachment
%    body.id = 'image_id';
%    body.contentType = 'image/jpg';
%    body.media = 'www.mathworks.com';
%    attachment = azure.documentdb.Attachment(jsonencode(body));
%    attachmentResponse = docClient.upsertAttachment(documentLink, attachment, options);
%    attachmentResource = attachmentResponse.getResource();

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(documentLink)
    write(logObj,'error','documentLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

if ~isa(attachment, 'azure.documentdb.Attachment')
    write(logObj,'error','attachment argument not of type azure.documentdb.Attachment');
end

resultJ = obj.Handle.upsertAttachment(documentLink, attachment.Handle, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
