classdef testgraphtest < matlab.unittest.TestCase
    % TESTGRAPHTEST This is a test stub for a unit testing
    % The assertions that you can use in your test cases:
    %
    %   A more detailed explanation goes here.
    %
    
    %(Copyright 2020, The MathWorks, Inc.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (TestMethodSetup)
        function testSetup(testCase)
            
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase)
            
        end
    end
    
    methods (Test)
        function testCreateGraph(testCase)
            % Create Client
            gClient = azure.gremlin.GremlinClient();
            
            % Query graph drop and submit to get results
            fprintf('Empty graph')
            queries = {"g.V().drop()"};            
            % Get resultset
            resultset = gClient.submit(queries)
            response = resultset.get
            
            % Create Fresh Airport graph
            vertextype = 'airport';
            property.code = {'AUS', 'DFW', 'LAX', 'JFK', 'ATL'};
            property.pk = 'pkairport';
            edgetype = 'route';
            from = {'aus','atl','atl','dfw','dfw','lax','lax','lax'};
            to = {'atl','dfw','jfk','jfk','lax','jfk','aus','dfw'};
            
            % Create 5 airport vertices
            for i = 1: numel(property.code)
                vertexquerystr{i} = strcat("g.addV('" ,vertextype, "').property('id','", property.code{i} ,"').property('pk','" ,property.pk, "')");
            end            
            % Submit and get results post execution
            resultset = gClient.submit(vertexquerystr);
            response = resultset.get;
            
            % Create edges/routes between 5 airport vertices
            for i = 1: numel(from)
                edgequerystr{i} = strcat("g.V('", upper(from{i}), "').addE('" ,edgetype, "').to(g.V('", upper(to{i}), "'))");
            end
            % Submit and get results post execution
            resultset = gClient.submit( edgequerystr);
            response = resultset.get;
             
            % Query routes from lax
            querystr = {"g.V('LAX').outE('route').inV().hasLabel('airport').values('id')"};
            % Submit and get results post execution
            resultset = gClient.submit(querystr);
            response = resultset.get;
            
            % Close client connection
            gClient.close
            
        end
    end
    
end

