classdef PartitionKeyDefinition < azure.object
% PARTITIONKEYDEFINITION Creates a new instance of a PartitionKeyDefinition
%
% Example:
%    % set /city as the partition key path
%    partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
%    partitionKeyFieldName = 'city';
%    partitionKeyPath = ['/' , partitionKeyFieldName];
%    paths = string(partitionKeyPath);
%    partitionKeyDefinition.setPaths(paths);
%    collectionDefinition.setPartitionKey(partitionKeyDefinition);

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = PartitionKeyDefinition(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.PartitionKeyDefinition')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                obj.Handle = com.microsoft.azure.documentdb.PartitionKeyDefinition(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.PartitionKeyDefinition();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end
end
