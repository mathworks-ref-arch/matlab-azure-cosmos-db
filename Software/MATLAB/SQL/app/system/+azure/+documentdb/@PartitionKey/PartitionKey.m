classdef PartitionKey < azure.object
% PARTITIONKEY Represents a partition key value in Cosmos DB
% A partition key identifies the partition where the document is stored.
%
% Example:
%    requestOptions = azure.documentdb.RequestOptions();
%    requestOptions.setScriptLoggingEnabled(true);
%    requestOptions.setPartitionKey(azure.documentdb.PartitionKey('Galway'));

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = PartitionKey(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.PartitionKey')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                % Initializes a new instance of the class with the PartitionKey
                % character vector
                obj.Handle = com.microsoft.azure.documentdb.PartitionKey(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        else
            write(logObj,'error','Invalid number of arguments');
        end

    end %function
end %methods
end %class
