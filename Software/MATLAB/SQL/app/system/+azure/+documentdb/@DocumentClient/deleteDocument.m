function result = deleteDocument(obj, documentLink, options)
% DELETEDOCUMENT Deletes a document by the document link
% Returns a ResourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(documentLink)
    write(logObj,'error','documentLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.deleteDocument(documentLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
