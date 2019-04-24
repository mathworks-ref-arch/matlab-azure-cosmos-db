classdef SqlQuerySpec < azure.object
% SQLQUERYSPEC Represents a SQL query in Azure Cosmos DB
%
% Example:
%    azure.documentdb.SqlQuerySpec(my_SqlQuerySpec_query_text);
%    or
%    azure.documentdb.SqlQuerySpec();
%    or
%    azure.documentdb.SqlQuerySpec(mySqlQuerySpecObject)

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = SqlQuerySpec(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.SqlQuerySpec')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                % Initializes a new instance of the class with the text of the query
                obj.Handle = com.microsoft.azure.documentdb.SqlQuerySpec(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.SqlQuerySpec();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end %function
end %methods
end %class
