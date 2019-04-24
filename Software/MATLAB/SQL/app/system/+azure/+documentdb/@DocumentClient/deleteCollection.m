function result = deleteCollection(obj, collectionLink, options)
% DELETECOLLECTION Deletes a document collection by the collection link
% Returns a ResourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','Expected collectionLink of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.deleteCollection(collectionLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
