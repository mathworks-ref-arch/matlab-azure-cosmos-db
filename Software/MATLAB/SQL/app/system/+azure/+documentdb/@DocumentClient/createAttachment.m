function result = createAttachment(obj, documentLink, attach, options)
% CREATEATTACHMENT Creates an attachment
% Returns a ResourceResponse.
%
% Example:
%    %% create an attachment
%    options = azure.documentdb.RequestOptions();
%    documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
%    body.id = 'image_id';
%    body.contentType = 'image/jpg';
%    body.media = 'www.mathworks.com';
%    attachment = azure.documentdb.Attachment(jsonencode(body));
%    attachmentResponse = docClient.createAttachment(documentLink, attachment, options);
%
%
%    %% create a media stream based attachment
%    % create sample data and write it to a file
%    data = rand(10);
%    tmpName = tempname;
%    dlmwrite(tmpName, data);
%
%    % configure attachment option settings
%    mediaOptions = azure.documentdb.MediaOptions();
%    slug = 'myAttachmentId';
%    % writing the data in ascii format in this case
%    contentType = 'text/plain';
%    mediaOptions.setSlug(slug);
%    mediaOptions.setContentType(contentType);
%
%    % create the attachment in Cosmos DB and get the response
%    attachmentResponse = docClient.createAttachment(documentLink, tmpName, mOptions);
%    attachmentResource = attachmentResponse.getResource();


% Copyright 2019 The MathWorks, Inc.
import java.io.FileInputStream

logObj = Logger.getLogger();

if ~ischar(documentLink)
    write(logObj,'error','Expected documentLink argument to be of type character vector');
end

if isa(attach, 'azure.documentdb.Attachment')
    if isa(options, 'azure.documentdb.RequestOptions')
        resultJ = obj.Handle.createAttachment(documentLink, attach.Handle, options.Handle);
        result = azure.documentdb.ResourceResponse(resultJ);
    else
        write(logObj,'error','options argument not of type RequestOptions');
    end
elseif ischar(attach)
    % In this attach should be the absolute path file you wish to attach
    if isa(options, 'azure.documentdb.MediaOptions')
        % check the file exists before trying to open the stream
        if exist(attach,'file') ~= 2
            write(logObj,'error',['File not found: ',attach]);
        else
            inpStream = java.io.FileInputStream(attach);
            resultJ = obj.Handle.createAttachment(documentLink, inpStream, options.Handle);
            inpStream.close();
            result = azure.documentdb.ResourceResponse(resultJ);
        end
    else
        write(logObj,'error','options argument not of type MediaOptions');
    end
else
    write(logObj,'error','attach argument not of type Attachment or character vector');
end

end %function
