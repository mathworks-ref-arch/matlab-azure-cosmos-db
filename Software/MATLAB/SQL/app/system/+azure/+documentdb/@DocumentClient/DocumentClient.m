classdef DocumentClient < azure.object
    % DOCUMENTCLIENT Client used to configure and execute requests
    % Provides a client-side representation of the Azure Cosmos DB service.
    % This client is used to configure and execute requests against the service.
    % The service client holds the endpoint and credentials used to access
    % the Azure Cosmos DB service.
    %
    % Example:
    %    % using default credentials
    %    database = azure.documentdb.Database('mydbname');
    %    docClient = azure.documentdb.DocumentClient()
    %    docClient.createDatabase(database);
    %    % or using paramters to speify connections details
    %    docClient = azure.documentdb.DocumentClient('serviceEndpoint', 'https://mycosmosaccount.documents.azure.com:443/', 'masterKey', 'p6iZa[MY REDACTED MASTER KEY]YZ7Q==')
    %    % or where a non default configuration file holding credentials is used
    %    docClient = azure.documentdb.DocumentClient('configurationFile', '/my/path/myconfigfile.json')

    % Copyright 2019 The MathWorks, Inc.

    properties(SetAccess = private)
        % Stores the username used to authenticate
        masterKey = [];
        % Stores the name of the Server(s) to which connection is established
        serviceEndpoint = [];
        % flag for automatic documentID generation
        disableAutomaticIdGeneration = 1; % default is disabled
    end

    methods
        %% Constructor
        function obj = DocumentClient(varargin)
            import com.microsoft.azure.documentdb.*;
            p = inputParser;
            p.CaseSensitive = false;
            p.FunctionName = 'DocumentClient';
            addParameter(p,'serviceEndpoint','');
            addParameter(p,'masterKey','');
            addParameter(p,'configurationFile','');
            parse(p,varargin{:});
            serviceEndpoint = p.Results.serviceEndpoint;
            masterKey = p.Results.masterKey;
            configurationFile = p.Results.configurationFile;

            % Check that version R2017b or later is being used
            if verLessThan('matlab','9.3')
                % Create a logger object
                logObj = Logger.getLogger();
                write(logObj,'error','MATLAB Release 2017b or newer is required');
            end

            % If the endpoint and key are not provided use the config file
            % If arguments are provided for both the key and endpoint they will
            % override a config file or default config
            if isempty(serviceEndpoint) && isempty(masterKey)
                % If a config file name is provided use it otherwise use the default
                if isempty(configurationFile)
                    obj.loadConfigurationSettings();
                else
                    obj.loadConfigurationSettings(configurationFile);
                end
            else
                % sets the objects parameters to the arguments
                obj.serviceEndpoint = serviceEndpoint;
                obj.masterKey = masterKey;
            end

            myConnectionPolicyJ = com.microsoft.azure.documentdb.ConnectionPolicy();
            myConnectionPolicyJ = myConnectionPolicyJ.GetDefault();
            myConsistencyEnumJ = com.microsoft.azure.documentdb.ConsistencyLevel.Session;
            obj.Handle = com.microsoft.azure.documentdb.DocumentClient(obj.serviceEndpoint, obj.masterKey, myConnectionPolicyJ, myConsistencyEnumJ);

        end %function
    end %methods
end %class
