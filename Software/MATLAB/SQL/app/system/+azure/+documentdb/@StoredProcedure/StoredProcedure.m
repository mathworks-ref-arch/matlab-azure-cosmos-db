classdef StoredProcedure < azure.object
% STOREDPROCEDURE Represents a a stored procedure in Azure Cosmos DB
% Cosmos DB allows stored procedures to be executed in the storage tier,
% against a document collection. The procedure is executed under ACID
% transactions on the primary storage partition of the specified collection.
% The procedure should be valid JSON as a character vector. One can compare the
% following with equivalent Java code here:
% https://github.com/Azure/azure-documentdb-java/blob/master/documentdb-examples/src/test/java/com/microsoft/azure/documentdb/examples/StoredProcedureSamples.java
%
% Example:
%    storedProcedureStr = ['{' ,...
%     '  "id" : "storedProcedureSample",' ,...
%     '  "body" : ',...
%     '    "function() {' ,...
%     '        var mytext = \"x\";' ,...
%     '        var myval = 1;' ,...
%     '        try {' ,...
%     '            console.log(\"The value of %s is %s.\", mytext, myval);' ,...
%     '            getContext().getResponse().setBody(\"Success!\");' ,...
%     '        }' ,...
%     '        catch(err) {' ,...
%     '            getContext().getResponse().setBody(\"inline err: [\" + err.number + \"] \" + err);' ,...
%     '        }' ,...
%     '     }"',...
%     '}'];
%    storedProcedure =  azure.documentdb.StoredProcedure(storedProcedureStr);
%    docClient.createStoredProcedure(collectionLink, storedProcedure, options);
%    storedProcLink = ['/dbs/',databaseId,'/colls/', collectionId,'/sprocs/','storedProcedureSample'];
%
% % Constructor options:
%    azure.documentdb.StoredProcedure(<StoredProcedure JSON character vector>);
%    or
%    azure.documentdb.StoredProcedure();
%    or
%    azure.documentdb.StoredProcedure(myStoredProcedureObject)

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = StoredProcedure(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.StoredProcedure')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                % Initializes a new instance of the class with the StoredProcedure
                % character vector
                obj.Handle = com.microsoft.azure.documentdb.StoredProcedure(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.StoredProcedure();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end %function
end %methods
end %class
