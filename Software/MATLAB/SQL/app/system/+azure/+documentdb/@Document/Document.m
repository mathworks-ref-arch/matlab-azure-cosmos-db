classdef Document < azure.object
% DOCUMENT Represents a document in Azure Cosmos DB
% A document is a structured JSON document. There is no set schema for the JSON
% documents, and a document may contain any number of custom properties as well
% as an optional list of attachments. Document is an application resource and
% can be authorized using the master key or resource keys.
%
% Examples:
%    azure.documentdb.Document(my_JSON_document_character_vector);
%    % or
%    azure.documentdb.Document();
%    % or
%    azure.documentdb.Document(myJavaDocumentObject)
%
%    create a document in a collection
%    documentContents = ['{' ,...
%            '   "id": "test-document",' ,...
%            '   "city" : "Galway",' ,...
%            '   "population" : 79934', ' }' ] ;
%    documentDefinition = azure.documentdb.Document(documentContents);
%    disableAutomaticIdGeneration = false;
%    documentResponse = docClient.createDocument(collectionLink, ...
%                   documentDefinition, options, disableAutomaticIdGeneration);


% Copyright 2019 The MathWorks, Inc.

methods
    function obj = Document(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.Document')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                obj.Handle = com.microsoft.azure.documentdb.Document(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.Document();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end %function
end %methods
end %class
