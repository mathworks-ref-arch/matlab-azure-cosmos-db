function setPartitionKey(obj, partitionKey)
% SETPARTITIONKEY Sets the collection's partition key definition
%
% Example:
%    % create the collection
%    collectionDefinition = azure.documentdb.DocumentCollection();
%    collectionId = 'mycollectionname';
%    collectionDefinition.setId(collectionId);
%    % Set /city as the partition key path
%    partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
%    partitionKeyFieldName = 'city';
%    partitionKeyPath = ['/' , partitionKeyFieldName];
%    paths = [string(partitionKeyPath)];
%    partitionKeyDefinition.setPaths(paths);
%    collectionDefinition.setPartitionKey(partitionKeyDefinition);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~isa(partitionKey, 'azure.documentdb.PartitionKeyDefinition')
    write(logObj,'error','partitionKey argument not of type azure.documentdb.PartitionKeyDefinition');
end

obj.Handle.setPartitionKey(partitionKey.Handle);

end
