classdef ConsistencyLevel < azure.object
% CONSISTENCYLEVEL Represents consistency levels supported by Cosmos DB client
% The requested level must match or be weaker than that provisioned for the
% database account. In order of strength levels are:
%    Strong
%    BoundedStaleness
%    Session
%    Eventual
% The default value used when a DocumentClient is created is Session.
%
% Example:
%    myConsistencyLevel = azure.documentdb.ConsistencyLevel.Strong;
%    docClient = azure.documentdb.DocumentClient('consistencyLevel', myConsistencyLevel)

% Copyright 2019 The MathWorks, Inc.

    enumeration
        BoundedStaleness
        ConsistentPrefix
        Eventual
        Session
        Strong
    end

    methods
        function typeJ = toJava(obj)
            switch obj
            case azure.documentdb.ConsistencyLevel.BoundedStaleness
                typeJ = com.microsoft.azure.documentdb.ConsistencyLevel.BoundedStaleness;
            case azure.documentdb.ConsistencyLevel.ConsistentPrefix
                typeJ = com.microsoft.azure.documentdb.ConsistencyLevel.ConsistentPrefix;
            case azure.documentdb.ConsistencyLevel.Eventual
                typeJ = com.microsoft.azure.documentdb.ConsistencyLevel.Eventual;
            case azure.documentdb.ConsistencyLevel.Session
                typeJ = com.microsoft.azure.documentdb.ConsistencyLevel.Session;
            case azure.documentdb.ConsistencyLevel.Strong
                typeJ = com.microsoft.azure.documentdb.ConsistencyLevel.Strong;
            otherwise
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid azure.documentdb.ConsistencyLevel');
            end
        end
    end

end %class
