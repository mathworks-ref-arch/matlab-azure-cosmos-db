classdef testGremlinclient < matlab.unittest.TestCase
    % TESTGREMLINCLIENT This is a test stub for a unit testing the gremlin
    % client creation and its method close()
    
    %(Copyright 2020, The MathWorks, Inc.)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        logObj
    end
    
    methods (TestMethodSetup)
        function testSetup(testCase)
            testCase.logObj = Logger.getLogger();
            testCase.logObj.DisplayLevel = 'verbose';
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase)
            
        end
    end
    
    methods (Test)
        function testGremlinClientObject(testCase)
            % Reads default config file
            write(testCase.logObj,'debug','Testing Gremlin client constructor');
            
            gremlinClient = azure.gremlin.GremlinClient();
            write(testCase.logObj,'debug','Gremlin client to Azure Cosmosdb created');
            
            testCase.verifyNotEmpty(gremlinClient);
            write(testCase.logObj,'debug','Gremlin client not empty');
            
            testCase.verifyNotEmpty(gremlinClient.Handle);
            write(testCase.logObj,'debug','Gremlin client Handle exists');
            
            testCase.verifyClass(gremlinClient,'azure.gremlin.GremlinClient');
            testCase.verifyClass(gremlinClient.Handle,'org.apache.tinkerpop.gremlin.driver.Client$ClusteredClient');
            write(testCase.logObj,'debug','Gremlin client class verified');
            
            gremlinClient.close
            write(testCase.logObj,'debug','Gremlin client to Azure Cosmosdb closed');
        end
    end
    
end

