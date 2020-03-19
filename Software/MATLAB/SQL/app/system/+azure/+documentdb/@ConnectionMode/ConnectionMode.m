classdef ConnectionMode < azure.object
    % CONNECTIONMODE Enumeration for modes used by the client in Cosmos DB
    %
    % DirectHttps specifies that requests to resources are made directly to the
    % data nodes through HTTPS. In DirectHttps mode, all requests to server
    % resources within a collection are made directly to the data nodes using
    % the HTTPS transport protocol.
    % Certain operations on account or database level resources, such as
    % databases, collections and users, etc.,
    % are always routed through the gateway using HTTPS.
    %
    % Gateway specifies that requests to resources are made through a gateway
    % proxy using HTTPS. In Gateway mode, all requests are made through a
    % gateway proxy.

    % Copyright 2019 The MathWorks, Inc.

    enumeration
        DirectHttps
        Gateway
    end

    methods
        function typeJ = toJava(obj)
            switch obj
            case azure.documentdb.ConnectionMode.DirectHttps
                typeJ = com.microsoft.azure.documentdb.ConnectionMode.DirectHttps;
            case azure.documentdb.ConnectionMode.Gateway
                typeJ = com.microsoft.azure.documentdb.ConnectionMode.Gateway;
            otherwise
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid azure.documentdb.ConnectionMode');
            end
        end
    end
end %class
