function result = createDocument(obj, collectionLink, document, options, disableAutomaticIdGeneration)
% CREATEDOCUMENT Creates a document
% Creation using POJO is not currently supported.
% Returns a ResourceResponse.
%
% Example:
%   % create a document in a collection
%   collectionLink = documentCollection.getSelfLink();
%   documentContents = ['{' ,...
%                '   "id": "test-document",' ,...
%                '   "city" : "Galway",' ,...
%                '   "population" : 79934', ' }' ] ;
%   documentDefinition = azure.documentdb.Document(documentContents);
%   disableAutomaticIdGeneration = false;
%   documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','collectionLink argument not of type character vector');
end

if ~isa(document, 'azure.documentdb.Document')
    write(logObj,'error','Expected document argument to be of type azure.documentdb.Document');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.createDocument(collectionLink, document.Handle, options.Handle, disableAutomaticIdGeneration);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
