function result = getQueryCellArray(obj)
% GETQUERYCELLARRAY Convert feedResponse Java collection to a cell array
% This method can be used as an alternative to code like the following:
%
%   feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
%   iteratorJ = feedResponse.Handle.getQueryIterator();
%   while iteratorJ.hasNext()
%       d = azure.documentdb.Document(iteratorJ.next());
%   end
%
% It returns the results as a cell array rather than requiring the Java iterator
% If the feedResponse contains objects of type: Database, DocumentCollection,
% Document, Attachment, Offer, Trigger, StoredProcedure or UserDefinedFunction
% They will be returned as MATLAB objects otherwise the underlying Java object
% will be returned.

% Copyright 2019 The MathWorks, Inc.

iteratorJ = obj.Handle.getQueryIterator();

n = 1;
result = {};
while iteratorJ.hasNext()
    next = iteratorJ.next();
    switch class(next)
    case 'com.microsoft.azure.documentdb.Database'
        result{n} = azure.documentdb.Database(next); %#ok<*AGROW>
    case 'com.microsoft.azure.documentdb.DocumentCollection'
        result{n} = azure.documentdb.DocumentCollection(next);
    case 'com.microsoft.azure.documentdb.Document'
        result{n} = azure.documentdb.Document(next);
    case 'com.microsoft.azure.documentdb.Attachment'
        result{n} = azure.documentdb.Attachment(next);
    case 'com.microsoft.azure.documentdb.Offer'
        result{n} = azure.documentdb.Offer(next);
    case 'com.microsoft.azure.documentdb.Trigger'
        result{n} = azure.documentdb.Trigger(next);
    case 'com.microsoft.azure.documentdb.StoredProcedure'
        result{n} = azure.documentdb.StoredProcedure(next);
    case 'com.microsoft.azure.documentdb.UserDefinedFunction'
        result{n} = azure.documentdb.UserDefinedFunction(next);
    otherwise
        result{n} = next;
    end
    n = n + 1;
end

end
