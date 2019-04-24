classdef Database < azure.object
% DATABASE Represents a Database in the Azure Cosmos DB database service
% A database manages users, permissions and a set of collections
% Each Azure Cosmos DB Service is able to support multiple independent named
% databases, with the database being the logical container for data.
% Each Database consists of one or more collections, each of which in turn
% contain one or more documents. Since databases are an an administrative
% resource and the Service Master Key will be required in order to access and
% successfully complete any action using the User APIs.
%
% If a database name is provided to the constructor rather than via the setId
% method a MATLAB struct is created with a field name of id for the name.
% This struct is then JSON encoded and used as the database name. Both
% approaches are equivalent.
% A database can also be created from a Java
% com.microsoft.azure.documentdb.Database object.

% Examples:
%    database = azure.documentdb.Database()
%    database.setId('mydbname')
%    % or
%    database = azure.documentdb.Database('mydbname');
%    % or
%    database = azure.documentdb.Database(myJavaDatabaseObject);

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = Database(varargin)

        % Create a logger object
        logObj = Logger.getLogger();

        if nargin == 1
            if ischar(varargin{1})
                % Build a json id string with the name
                dbNameJson = jsonencode(struct('id',varargin{1}));
                obj.Handle = com.microsoft.azure.documentdb.Database(dbNameJson);
            elseif isa(varargin{1}, 'com.microsoft.azure.documentdb.Database')
                obj.Handle = varargin{1};
            else
                write(logObj,'error','Unexpected argument type');
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.Database();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end
end
