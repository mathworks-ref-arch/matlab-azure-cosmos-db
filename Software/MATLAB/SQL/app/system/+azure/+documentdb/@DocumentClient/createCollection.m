function result = createCollection(obj, databaseLink, collection, options)
% CREATECOLLECTION Creates a document collection
% Returns a ResourceResponse.
%
% Example:
%    docClient = azure.documentdb.DocumentClient()
%    database = azure.documentdb.Database('mydbname');
%    docClient.createDatabase(database);
%    databaseLink = ['/dbs/',database.getId()];
%    myCollection = azure.documentdb.DocumentCollection('mycollectionname');
%    docClient.createCollection(databaseLink, myCollection);

% Copyright 2019 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if ~isa(collection, 'azure.documentdb.DocumentCollection')
    write(logObj,'error','Expected collection argument to be of type azure.documentdb.DocumentCollection');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type RequestOptions');
end

resultJ = obj.Handle.createCollection(databaseLink, collection.Handle, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end % createCollection
