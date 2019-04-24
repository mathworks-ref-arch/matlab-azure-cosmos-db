classdef IncludedPath < azure.object
% INCLUDEDPATH Creates an instance of an IncludedPath when setting IndexingPolicy
%
% Example:
%    % set indexing policy to be range range for string and number
%    indexingPolicy = azure.documentdb.IndexingPolicy();
%    includedPath = azure.documentdb.IncludedPath();
%    includedPath.setPath('/*');
%    stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
%    numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
%    indexes = {stringRangeIndex,numberRangeIndex};
%    includedPath.setIndexes(indexes);
%    % in this case only one path is set, more than one path may be set
%    includedPaths = {includedPath};
%    indexingPolicy.setIncludedPaths(includedPaths);

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = IncludedPath(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.IncludedPath')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                % JSON string case
                obj.Handle = com.microsoft.azure.documentdb.IncludedPath(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.IncludedPath();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end
end
