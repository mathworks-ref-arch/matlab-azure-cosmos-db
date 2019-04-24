function result = getResource(obj)
% GETRESOURCE Gets the resource for the request
% Returns an object of the type represented by the Response

% Copyright 2019 The MathWorks, Inc.

T = obj.Handle.getResource();

switch class(T)
case 'com.microsoft.azure.documentdb.Database'
    result = azure.documentdb.Database(T);
case 'com.microsoft.azure.documentdb.DocumentCollection'
    result = azure.documentdb.DocumentCollection(T);
case 'com.microsoft.azure.documentdb.Document'
    result = azure.documentdb.Document(T);
case 'com.microsoft.azure.documentdb.Attachment'
    result = azure.documentdb.Attachment(T);
case 'com.microsoft.azure.documentdb.Offer'
    result = azure.documentdb.Offer(T);
case 'com.microsoft.azure.documentdb.Trigger'
    result = azure.documentdb.Trigger(T);
case 'com.microsoft.azure.documentdb.UserDefinedFunction'
    result = azure.documentdb.UserDefinedFunction(T);
otherwise
    result = T;
end

end
