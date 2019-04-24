classdef Attachment < azure.object
% ATTACHMENT Represents a document attachment in Cosmos DB
% A document can contain zero or more attachments. Attachments can be of any
% MIME type and are stored externally in Azure Blob storage.
% Attachments are automatically deleted when the parent document is deleted.
% Attachments can be managed or unmanaged. An unmanaged attachments is not
% attached rather a link to external storage is provided. With managed
% attachments storage is 'managed' by Cosmos DB.
%
% Examples:
%    % The attachment constructor is called as follows:
%    % Passing the attachment as a JSON encoded character vector
%    azure.documentdb.Attachment(my_JSON_attachment_character_vector);
%    % with no arguments, id, contentType and media values to be set later
%    azure.documentdb.Attachment();
%    % using an existing Java attachment object of type com.microsoft.azure.documentdb.Attachment
%    azure.documentdb.Attachment(myAttachmentObject)
%
%    % create an attachment using a JSON character vector
%    % create the required documentLink and options arguments
%    options = azure.documentdb.RequestOptions();
%    documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
%    % create a body struct and populate the id, contentType and media fields
%    body.id = 'image_id';
%    body.contentType = 'image/jpg';
%    body.media = 'www.mathworks.com';
%    % JSON encode the struct an create the local attachment object using it
%    attachment = azure.documentdb.Attachment(jsonencode(body));
%    % call the DocumentClient createAttachment method to create the attachment
%    % in Cosmos DB
%    attachmentResponse = docClient.createAttachment(documentLink, attachment, options);
%    % get the resource from the response representing the created object, if required
%    attachmentResource = attachmentResponse.getResource();

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = Attachment(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.Attachment')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                obj.Handle = com.microsoft.azure.documentdb.Attachment(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.Attachment();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end %function
end %methods
end %class
