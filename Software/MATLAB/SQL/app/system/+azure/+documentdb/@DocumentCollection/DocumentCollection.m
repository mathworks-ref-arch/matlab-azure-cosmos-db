classdef DocumentCollection < azure.object
% DOCUMENTCOLLECTION Represents a document collection in Cosmos DB
% A collection contains documents. A database may contain zero or more
% collections and each collection consists of zero or more JSON documents.
% The documents in a collection do not need to share the same structure.
%
% Example:
%    azure.documentdb.DocumentCollection('mycollectionname');
%    % or
%    azure.documentdb.DocumentCollection();
%    % or using a Java com.microsoft.azure.documentdb.DocumentCollection object
%    azure.documentdb.DocumentCollection(myDocumentCollectionObject)

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = DocumentCollection(varargin)

        % Create a logger object
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.DocumentCollection')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                collectionIdJson = jsonencode(struct('id',varargin{1}));
                obj.Handle = com.microsoft.azure.documentdb.DocumentCollection(collectionIdJson);
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.DocumentCollection();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end
end
