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

    % Copyright 2019 The MathWorks, Inc.

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
        function testMonogClient(testCase)
            %% Basic test of connectivity to Cosmos DB Mongo API
            % full test takes place in the context of MATLAB + Database
            % Toolbox + Database Toolbox interface for MongoDB
            disp('Runnning testMonogClient');

            %% Configure paths and credentials
            % get the test/unit directory path
            here = fileparts(mfilename('fullpath'));
            % go up two levesl to get .../Azure-Cosmos-DB/Software/MATLAB/MongoDB
            mongoRoot = fileparts(fileparts(here));
            % add to the start of the path so this package's modified version of the
            % mongo.m file is found before the normal version
            addpath(mongoRoot,'-begin');
            % set a path to a default credentials file
            credFile = fullfile(mongoRoot, 'config','mongodb.json');
            % convert the values stored there to a struct
            config = jsondecode(fileread(credFile));
            % check the struct is populated
            testCase.verifyNotEmpty(config.password);
            testCase.verifyNotEmpty(config.accountName);
            databaseName = "mytestdb";

            %% Create connection to Cosmos DB Mongo API
            % connect to mongodb
            endPoint = strcat(string(config.accountName), ".documents.azure.com");
            conn = mongo(endPoint, 10255, databaseName,...
                         "UserName", string(config.accountName),...
                         "Password", string(config.password),...
                         "AuthMechanism", "MONGODB_CR", "SSLEnable", true);
            testCase.verifyNotEmpty(conn.CollectionNames);
            % create a collection
            myCollectionName = 'MongoTestCollection';
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

            % close connection
            conn.close();
        end

    end % methods
end % class
