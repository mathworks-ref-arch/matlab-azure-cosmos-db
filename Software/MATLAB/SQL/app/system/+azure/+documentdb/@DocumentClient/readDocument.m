function result = readDocument(obj, documentLink, options)
% READDOCUMENT Reads a document by the document link
%
% Example:
%    documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
%    % assuming a multi partition collection, partition key has to be provided
%    options = azure.documentdb.RequestOptions();
%    options.setPartitionKey(azure.documentdb.PartitionKey('Galway'));
%    % read document using the collectionlink and the provided partition key
%    response = docClient.readDocument(documentLink, options);
%    % access request charge associated with document read
%    % access individual fields
%    readDocument = response.getResource();

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(documentLink)
    write(logObj,'error','documentLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.readDocument(documentLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
