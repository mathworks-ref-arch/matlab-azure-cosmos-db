classdef testMongoDB < matlab.unittest.TestCase
    % TESTDOCUMENTDB This is a test stub for a unit testing
    % The assertions that you can use in your test cases:
    %
    %    assertTrue
    %    assertFalse
    %    assertEqual
    %    assertFilesEqual
    %    assertElementsAlmostEqual
    %    assertVectorsAlmostEqual
    %    assertExceptionThrown
    %
    %   A more detailed explanation goes here.
    %
    % Notes:
    
    % Copyright 2019-2021 The MathWorks, Inc.
    
    properties
        % MongoDB testDatabase name - update with actual value -
        testCase.databaseName = 'mbcosmosdbmongodbtest';
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
            
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        function testMongoClient(testCase)
            %% Basic test of connectivity to Cosmos DB Mongo API
            % full test takes place in the context of MATLAB + Database
            % Toolbox + Database Toolbox interface for MongoDB
            disp('Running testMongoClient');
            
            %% Configure paths and credentials
            % get the test/unit directory path
            here = fileparts(mfilename('fullpath'));
            % go up two levels to get .../Azure-Cosmos-DB/Software/MATLAB/MongoDB
            mongoRoot = fileparts(fileparts(here));
            % set a path to a default credentials file
            credFile = fullfile(mongoRoot, 'config','mongodb.json');
            % convert the values stored there to a struct
            config = jsondecode(fileread(credFile));
            % check the struct is populated
            testCase.verifyNotEmpty(config.password);
            testCase.verifyNotEmpty(config.accountName);
            
            %% Create connection to Cosmos DB Mongo API
            % connect to MongoDB
            endPoint = strcat(string(config.accountName), ".documents.azure.com");
            conn = mongo(endPoint, 10255, testCase.databaseName,...
                "UserName", string(config.accountName),...
                "Password", string(config.password),...
                "AuthMechanism", "SCRAM_SHA_1", "SSLEnabled", true);
            testCase.verifyNotEmpty(conn.CollectionNames);
            % if the collection already exists e.g. from a previous test
            % drop it
            myCollectionName = 'MongoTestCollection';
            if any(contains(conn.CollectionNames, myCollectionName))
                conn.dropCollection(myCollectionName);
            end
            testCase.verifyFalse(any(contains(conn.CollectionNames, myCollectionName)));
            % create a new empty collection for testing
            conn.createCollection(myCollectionName);
            
            % see if there are anything in the collection already
            dataCount = count(conn, myCollectionName);
            testCase.verifyEqual(dataCount, 0);
            
            % sample data entries
            LastName = {'Sanchez';'Johnson';'Li';'Diaz';'Brown'};
            Age = [38;43;38;40;49];
            Smoker = logical([1;0;1;0;1]);
            Height = [71;69;64;67;64];
            Weight = [176;163;131;133;119];
            BloodPressure = [124 93; 109 77; 125 83; 117 75; 122 80];
            T = table(LastName,Age,Smoker,Height,Weight,BloodPressure);
            
            % put some data into MongoDB from a Table
            data = conn.insert(myCollectionName, T);
            dataCount = count(conn, myCollectionName);
            testCase.verifyEqual(dataCount, 5);
            
            % read back some data
            result = conn.find(myCollectionName);
            testCase.verifyEqual(result(1).Age, Age(1));
            testCase.verifyEqual(result(5).Age, Age(5));
            testCase.verifyTrue(strcmp(result(1).LastName, LastName{1}));            
            testCase.verifyClass(result(1).Smoker, 'logical');
            
            % clean up
            conn.dropCollection(myCollectionName);
            conn.close();
        end
        
        function testInfNaN(testCase)
            %% Round trip +/-Inf & NaN
            disp('Running testInfNaN');
            
            %% Configure paths and credentials
            % get the test/unit directory path
            here = fileparts(mfilename('fullpath'));
            % go up two levels to get .../Azure-Cosmos-DB/Software/MATLAB/MongoDB
            mongoRoot = fileparts(fileparts(here));
            % set a path to a default credentials file
            credFile = fullfile(mongoRoot, 'config','mongodb.json');
            % convert the values stored there to a struct
            config = jsondecode(fileread(credFile));
            % check the struct is populated
            testCase.verifyNotEmpty(config.password);
            testCase.verifyNotEmpty(config.accountName);
            
            %% Create connection to Cosmos DB Mongo API
            % connect to MongoDB
            endPoint = strcat(string(config.accountName), ".documents.azure.com");
            conn = mongo(endPoint, 10255, testCase.databaseName,...
                "UserName", string(config.accountName),...
                "Password", string(config.password),...
                "AuthMechanism", "SCRAM_SHA_1", "SSLEnabled", true);
            testCase.verifyNotEmpty(conn.CollectionNames);
            % create a collection
            myCollectionName = 'MongoTestCollection';
            if any(contains(conn.CollectionNames, myCollectionName))
                conn.dropCollection(myCollectionName);
            end
            testCase.verifyFalse(any(contains(conn.CollectionNames, myCollectionName)));
            % create a new empty collection for testing
            conn.createCollection(myCollectionName);
            % see if there are anything in the collection already
            dataCount = count(conn, myCollectionName);
            testCase.verifyEqual(dataCount, 0);
            
            % sample data entries
            doc1.dArray =  [1, 2.0, -Inf, Inf, NaN];
            doc1.jsonStrNull = jsonencode(doc1.dArray);
            doc1.jsonStrConv = jsonencode(doc1.dArray, 'ConvertInfAndNaN', false);
            insVal1 = conn.insert(myCollectionName, doc1);
            testCase.verifyEqual(insVal1, 1);
            
            result = conn.find(myCollectionName);
            % result.dArray expected to return: 1     2   NaN   NaN   NaN
            % Note +/-Inf do not round trip
            testCase.verifyClass(result.dArray(1), 'double');
            testCase.verifyClass(result.dArray, 'double');
            testCase.verifyEqual(result.dArray(1), 1);
            testCase.verifyEqual(result.dArray(2), 2);
            testCase.verifyEqual(result.dArray(3), NaN);
            testCase.verifyEqual(result.dArray(4), NaN);
            testCase.verifyEqual(result.dArray(5), NaN);

            % result.jsonStrNull expected to return: '[1,2,null,null,null]'
            % Note +/-Inf do not round trip
            jsonStrNullDecoded = jsondecode(result.jsonStrNull);
            testCase.verifyClass(jsonStrNullDecoded, 'double');
            testCase.verifyEqual(jsonStrNullDecoded(1), 1);
            testCase.verifyEqual(jsonStrNullDecoded(2), 2);
            testCase.verifyEqual(jsonStrNullDecoded(3), NaN);
            testCase.verifyEqual(jsonStrNullDecoded(4), NaN);
            testCase.verifyEqual(jsonStrNullDecoded(5), NaN);
            
            % result.jsonStrConv expected to return:  '[1,2,-Infinity,Infinity,NaN]'
            jsonStrConvDecoded = jsondecode(result.jsonStrConv);
            testCase.verifyClass(jsonStrConvDecoded, 'double');
            testCase.verifyEqual(jsonStrConvDecoded(1), 1);
            testCase.verifyEqual(jsonStrConvDecoded(2), 2);
            testCase.verifyEqual(jsonStrConvDecoded(3), -Inf);
            testCase.verifyEqual(jsonStrConvDecoded(4), Inf);
            testCase.verifyEqual(jsonStrConvDecoded(5), NaN);
            
            % clean up
            conn.dropCollection(myCollectionName);
            conn.close();
        end
        
    end % methods
end % class
