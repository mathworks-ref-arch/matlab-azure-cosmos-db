classdef IndexingPolicy < azure.object
% INDEXINGPOLICY Options associated with feed methods in Cosmos DB
%
% Examples:
%    azure.documentdb.IndexingPolicy();
%    % or using a Java com.microsoft.azure.documentdb.IndexingPolicy object
%    azure.documentdb.IndexingPolicy(myIndexingPolicyObject)
%    % or using a JSON character vector
%    azure.documentdb.IndexingPolicy(myJSONCharacterVector)

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = IndexingPolicy(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.IndexingPolicy')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                % assume a json string
                obj.Handle = com.microsoft.azure.documentdb.IndexingPolicy(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.IndexingPolicy();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end %function
end %methods
end %class
