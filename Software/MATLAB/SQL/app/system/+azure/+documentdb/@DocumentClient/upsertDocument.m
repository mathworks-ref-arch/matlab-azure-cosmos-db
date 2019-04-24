function result = upsertDocument(obj, collectionLink, document, options, disableAutomaticIdGeneration)
% UPSERTDOCUMENT Upserts a document to a collection
% Upsert provides an atomically safe alternative to a create or replace
% operation preceded by a read.
% Returns a ReourceResponse.
%
% Example:
%    create a document in the collection
%    documentContents = ['{' ,...
%                '   "id": "test-document",' ,...
%                '   "city" : "Galway",' ,...
%                '   "population" : 79934', ' }' ] ;
%    documentDefinition = azure.documentdb.Document(documentContents);
%    disableAutomaticIdGeneration = false;
%    % upsert the document to the database
%    documentResponse = docClient.upsertDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','collectionLink argument not of type character vector');
end

if ~isa(document, 'azure.documentdb.Document')
    write(logObj,'error','options argument not of type azure.documentdb.Document');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

if ~islogical(disableAutomaticIdGeneration)
    write(logObj,'error','disableAutomaticIdGeneration argument not of logical');
end

resultJ = obj.Handle.upsertDocument(collectionLink, document.Handle, options.Handle, disableAutomaticIdGeneration);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
