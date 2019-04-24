function result = readCollection(obj, collectionLink, options)
% READCOLLECTION Reads a document collection by the collection link
% Returns a ReourceResponse.
%
% Example:
%    options = azure.documentdb.RequestOptions();
%    documentCollection = collectionResponse.getResource();
%    collectionLink = documentCollection.getSelfLink();
%    readResponse = docClient.readCollection(collectionLink, options);
%    readCollection = readResponse.getResource();

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','collectionLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.readCollection(collectionLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
