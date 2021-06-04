classdef objectgremlin  < handle
    % OBJECTGREMLIN Returns Root object for Azure.GremlinClient
    %
    % Example:
    %
    %       gremlinclient = azure.gremlinclient('credentials.yml')
    %
    %           gremlinclient =
    %
    %               GremlinClient with properties:
    %                Handle: [1x1 org.apache.tinkerpop.gremlin.driver.Client$ClusteredClient]

    properties
        Handle;
    end

    methods
        %% Constructor
        function obj = gremlinobject(~, varargin)
            % logObj = Logger.getLogger();
            % write(logObj,'debug','Creating root object');
        end
    end

end
