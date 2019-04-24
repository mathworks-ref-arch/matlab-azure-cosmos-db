function setIndexingPolicy(obj, indexingPolicy)
% SETINDEXINGPOLICY Sets Sets the indexing policy
%
% Example:
%    % create the collection
%    collectionDefinition = azure.documentdb.DocumentCollection();
%    collectionId = 'mycollectionname';
%    collectionDefinition.setId(collectionId);
%    % set indexing policy to be range range for string and number
%    indexingPolicy = azure.documentdb.IndexingPolicy();
%    includedPath = azure.documentdb.IncludedPath();
%    includedPath.setPath('/*');
%    stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
%    numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
%    indexes = {stringRangeIndex, numberRangeIndex};
%    includedPath.setIndexes(indexes);
%    includedPaths = {includedPath};
%    indexingPolicy.setIncludedPaths(includedPaths);
%    collectionDefinition.setIndexingPolicy(indexingPolicy);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~isa(indexingPolicy, 'azure.documentdb.IndexingPolicy')
    write(logObj,'error','indexingPolicy argument not of type azure.documentdb.IndexingPolicy');
end

obj.Handle.setIndexingPolicy(indexingPolicy.Handle);

end
