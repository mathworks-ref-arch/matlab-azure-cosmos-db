classdef GremlinClient  < azure.objectgremlin
    % GREMLINCLIENT Client used to configure and execute requests
    %
    % Provides a client-side representation of the Azure Cosmos DB service.
    % This client is used to configure and execute requests against the service.
    % The service client holds the endpoint and credentials used to access
    % the Azure Cosmos DB service.
    %
    % Example:
    %
    %    1. For specifying a credentials file explicitly with service endpoint, database name, graph name
    %    and authentication details as an input argument
    %
    %    gremlinclient = azure.gremlin.GremlinClient('credentials.yml')
    %
    %      gremlinclient =
    %
    %          GremlinClient with properties:
    %             Handle: [1×1 org.apache.tinkerpop.gremlin.driver.Client$ClusteredClient]
    %
    %    2. For using default credentials file 'gremlindb.yml' containing service endpoint, database name, graph name
    %    and authentication details, no input argument is needed. The
    %    default 'gremlindb.yml' file should be on path. e.g. Software/MATLAB/config/gremlindb.yml
    %
    %    gremlinclient = azure.gremlin.GremlinClient()
    %
    %      gremlinclient =
    %
    %          GremlinClient with properties:
    %             Handle: [1×1 org.apache.tinkerpop.gremlin.driver.Client$ClusteredClient]
    
    %(Copyright 2020, The MathWorks, Inc.)
    properties
    end
    
    methods
        %% Constructor
        function obj = GremlinClient(varargin)
            % Import base Apache Tinkerpop libraries
            % Ref: https://tinkerpop.apache.org/javadocs/current/full/org/apache/tinkerpop/gremlin/driver/package-summary.html
            
            import org.apache.tinkerpop.gremlin.driver.Client;
            import org.apache.tinkerpop.gremlin.driver.Cluster;
            import org.apache.tinkerpop.gremlin.driver.Result;
            import org.apache.tinkerpop.gremlin.driver.ResultSet;
            import java.io.File;
            
            % Setting up the Logger
            logObj = Logger.getLogger();
            logObj.MsgPrefix = 'Azure:GREMLIN';
            
            % Checking for JVM installation and MATLAB version for support
            if ~usejava('jvm')
                write(logObj,'error','MATLAB must be used with the JVM enabled');
            end
            if verLessThan('matlab','9.2') % R2017a
                write(logObj,'error','MATLAB Release 2017a or newer is required');
            end
            
           
            % Configure log4j if a properties file exists
            % start in <package directory>/matlab-azure-cosmos-db/Software/MATLAB/Gremlin/app/system/+azure/+gremlin/@GremlinClient/
            % and move up to <package directory>/matlab-azure-cosmos-db/Software/MATLAB/Gremlin
            basePath = fileparts(fileparts(fileparts(fileparts(fileparts(fileparts(fileparts(mfilename('fullpath'))))))));
            % append the properties file location and configure it
            log4jPropertiesPath = fullfile(basePath,'Gremlin', 'lib', 'jar', 'log4j.properties');
            if exist(log4jPropertiesPath, 'file') == 2
                org.apache.log4j.PropertyConfigurator.configure(log4jPropertiesPath);
            end
            
            
            % Detecting credentials either explicitly passed by user or
            % default credentials on path
            %
            % credentialsJ = File(which("gremlindb.yml"));
            
            if nargin>0 % explicitly passed input credentials
                % get file location
                credentialsFilePath = which(varargin{1});
                % read file using Java File read API
                credentialsJ = File(credentialsFilePath);
                % check if fiile is valid
                if isempty(credentialsFilePath)
                    write(logObj,'error',['Could not find credentials file ' varargin{1} ' on path']);
                end
            else % no input arguments, look for default credentials
                try
                    % Load credentials for client
                    credentialsJ = File(which("gremlindb.yml"));
                catch
                    write(logObj,'error','Could not find the default credentials file gremlindb.yml within MATLAB/config');
                end
            end
            
            % Creating Cluster Builder object with credentials
            clusterBuilderJ = Cluster.build(credentialsJ);
            % Creating Cluster object by building Cluster.Builder
            cluster = clusterBuilderJ.create();
            % Creating Gremlin client
            gremlinClientJ = cluster.connect();
            % Setting Handle
            obj.Handle = gremlinClientJ;
        end
    end
    
end %class