function setPartitionKey(obj, partitionKey)
% SETPARTITIONKEY Sets partition key to identify the request's target partition
%
% Example:
%    partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
%    partitionKeyFieldName = 'city';
%    partitionKeyPath = ['/' , partitionKeyFieldName];
%    paths = string(partitionKeyPath);
%    partitionKeyDefinition.setPaths(paths);
%    collectionDefinition.setPartitionKey(partitionKeyDefinition);

% Copyright 2019 The MathWorks, Inc.

if ~isa(partitionKey, 'azure.documentdb.PartitionKey')
    logObj = Logger.getLogger();
    write(logObj,'error','partitionKey argument not of type azure.documentdb.PartitionKey');
else
    obj.Handle.setPartitionKey(partitionKey.Handle);
end

end
