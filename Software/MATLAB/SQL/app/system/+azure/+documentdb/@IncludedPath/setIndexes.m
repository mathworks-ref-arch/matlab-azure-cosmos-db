function setIndexes(obj, indexes)
% SETINDEXES Sets indexes for an includedPath
%
% Example:
%    includedPath = azure.documentdb.IncludedPath();
%    includedPath.setPath('/*');
%    stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
%    numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
%    indexes = {stringRangeIndex,numberRangeIndex};
%    includedPath.setIndexes(indexes);
%    includedPaths = {includedPath};
%    indexingPolicy.setIncludedPaths(includedPaths);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

% take a cell array of index objects
if ~iscell(indexes)
    write(logObj,'error','indexes argument not of type cell array');
end

if ~isvector(indexes)
    write(logObj,'error','indexes must be a vector');
end

for n = 1:numel(indexes)
    % only RangeIndex type is currently supported
    if ~isa(indexes{n},'azure.documentdb.RangeIndex')
        argType = class(indexes{n});
        write(logObj,'error',['Unexpected index of type: ',argType]');
    end
end

% build a Java ArrayList of their Handle objects
indexesListJ = java.util.ArrayList();
for n=1:numel(indexes)
    indexesListJ.add(indexes{n}.Handle);
end

try
    obj.Handle.setIndexes(indexesListJ)
catch ex
    disp(ex.message);
    me = MException('IncludedPath:SetIndexesFailure', 'setIndexes Error');
    throw(me);
end
end
