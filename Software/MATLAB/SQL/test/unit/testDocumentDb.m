classdef testDocumentDb < matlab.unittest.TestCase
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
        function testDocClientObject(testCase)
            % reads default config file
            disp('Running testDocClientObject');
            docClient = azure.documentdb.DocumentClient();
            testCase.verifyNotEmpty(docClient.masterKey);
            testCase.verifyNotEmpty(docClient.serviceEndpoint);
            testCase.verifyNotEmpty(docClient.Handle);
            testCase.verifyNotEmpty(docClient.disableAutomaticIdGeneration);
            testCase.verifyEqual(docClient.disableAutomaticIdGeneration, 1);
            docClient.close;
        end


        function testDocClientNonDefaultConfig(testCase)
            % reads non default config file
            disp('Running testDocClientNonDefaultConfig');
            configFile = which('documentdb.json');
            [filepath,~,~] = fileparts(configFile);
            NonDefaultConfigFile = fullfile(filepath,'NonDefaultConfigFile.json');
            status = copyfile(configFile, NonDefaultConfigFile);
            testCase.verifyTrue(status);

            % load alternative config settings and verify they were read
            docClient = azure.documentdb.DocumentClient('configurationFile', NonDefaultConfigFile);
            testCase.verifyNotEmpty(docClient.masterKey);
            testCase.verifyNotEmpty(docClient.serviceEndpoint);
            testCase.verifyNotEmpty(docClient.Handle);
            testCase.verifyNotEmpty(docClient.disableAutomaticIdGeneration);
            testCase.verifyEqual(docClient.disableAutomaticIdGeneration, 1);
            docClient.close;

            % remove the alternative config file
            delete(NonDefaultConfigFile);
        end


        function testDocClientNonDefaultConfigParams(testCase)
            % reads non default config file
            disp('Running testDocClientNonDefaultConfigParams');
            configFile = which('documentdb.json');
            config = jsondecode(fileread(which(configFile)));

            % load alternative config settings and verify they were read
            docClient = azure.documentdb.DocumentClient('serviceEndpoint', config.serviceEndpoint, 'masterKey', config.masterKey);
            testCase.verifyNotEmpty(docClient.masterKey);
            testCase.verifyNotEmpty(docClient.serviceEndpoint);
            testCase.verifyNotEmpty(docClient.Handle);
            testCase.verifyNotEmpty(docClient.disableAutomaticIdGeneration);
            testCase.verifyEqual(docClient.disableAutomaticIdGeneration,1);
            docClient.close;
        end


        function testDatabaseObject(testCase)
            disp('Running testDatabaseObject');
            % create a database object
            database = azure.documentdb.Database();
            testCase.verifyNotEmpty(database.Handle);
        end


        function testDatabaseObjectId(testCase)
            disp('Running testDatabaseObjectId');
            database = azure.documentdb.Database();

            % set the database id
            myName = 'unittestcosmosdb';
            database.setId(myName)
            result = database.getId;
            testCase.verifyEqual(myName,result);
        end


        function testDatabaseCreateReadDelete(testCase)
            % create & delete a database
            disp('Running testDatabaseCreateReadDelete');
            databaseId = 'unittestcosmosdb';

            % set database id
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();

            % if the database already exists delete it so the test is valid
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end

            % create the database and check its properties
            docClient.createDatabase(database, options);
            testCase.verifyTrue(docClient.existsDatabase(databaseLink, options));
            databaseLink = ['/dbs/',database.getId()];
            readResponse = docClient.readDatabase(databaseLink, options);
            readResult = readResponse.getResource();
            testCase.verifyEqual(char(readResult.getId()), database.getId());

            % delete the database
            docClient.deleteDatabase(databaseLink, options);
            testCase.verifyFalse(docClient.existsDatabase(databaseLink, options));
            docClient.close;
        end


        function testDatabaseCreateAndQuery(testCase)
            % create a database
            disp('Running testDatabaseCreateAndQuery');
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            databaseLink = ['/dbs/',database.getId()];
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);
            testCase.verifyTrue(docClient.existsDatabase(databaseLink, options));

            % Query the id of the database
            feedOptions = azure.documentdb.FeedOptions();
            queryStr = ['SELECT * FROM r where r.id = ''', databaseId,''''];
            queryResults = docClient.queryDatabases(queryStr, feedOptions);

            % use java handle methods to valid data there is a result and the
            % id is as expected
            iterator = queryResults.Handle.getQueryIterator();
            testCase.verifyTrue(iterator.hasNext());
            foundDatabaseJ = azure.documentdb.Database(iterator.next());
            testCase.verifyEqual(char(foundDatabaseJ.getId()), database.getId());
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testSqlQuerySpec(testCase)
            % use an SqlQuerySpec object to run a query
            disp('Running testSqlQuerySpec');
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            databaseLink = ['/dbs/',database.getId()];
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);
            testCase.verifyTrue(docClient.existsDatabase(databaseLink, options));

            % query as in previous test using Java HAndle methods
            feedOptions = azure.documentdb.FeedOptions();
            queryStr = ['SELECT * FROM r where r.id = ''', databaseId,''''];
            queryResults = docClient.queryDatabases(queryStr, feedOptions);
            iterator = queryResults.Handle.getQueryIterator();
            testCase.verifyTrue(iterator.hasNext());
            foundDatabaseJ = azure.documentdb.Database(iterator.next());
            testCase.verifyEqual(char(foundDatabaseJ.getId()), database.getId());

            % rerun the query but with a SqlQuerySpec, no java handle methods used
            querySpec = azure.documentdb.SqlQuerySpec(queryStr);
            feedResponse = docClient.queryDatabases(querySpec, feedOptions);

            % get results in a cell array & validate
            responseCellArray = feedResponse.getQueryCellArray();
            testCase.verifyEqual(char(responseCellArray{1}.getId()), database.getId());
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testCreateSinglePartitionCollection(testCase)
            % create a simple collection in a database
            % multi partition test follows later
            disp('Running testCreateSinglePartitionCollection');
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',databaseId];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create a collection
            collectionId = 'testCollection';
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionDefinition.setId(collectionId);
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % cleanup delete the collection & delete the database
            docClient.deleteCollection(collectionLink, options);
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testCollectionCreateReadDeleteQuery(testCase)
            % create a collection within a database
            disp('Running testCollectionCreateReadDelete');
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);
            testCase.verifyTrue(docClient.existsDatabase(databaseLink, options));

            % create a collection
            collectionId = 'mycollectionname';
            myCollection = azure.documentdb.DocumentCollection(collectionId);
            collectionResponse = docClient.createCollection(databaseLink, myCollection, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            readResponse = docClient.readCollection(collectionLink, options);
            readCollection = readResponse.getResource();
            testCase.verifyEqual(readCollection.getId(), documentCollection.getId());
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % query the collection
            feedOptions = azure.documentdb.FeedOptions();
            queryStr = ['SELECT * FROM r where r.id = ''', collectionId,''''];
            queryResults = docClient.queryCollections(databaseLink, queryStr, feedOptions);
            responseCellArray = queryResults.getQueryCellArray();
            queryCollectionLink = responseCellArray{1}.getSelfLink();
            testCase.verifyEqual(queryCollectionLink, collectionLink);
            testCase.verifyEqual(documentCollection.getId(), responseCellArray{1}.getId());
            docClient.deleteCollection(collectionLink, options);
            docClient.deleteDatabase(databaseLink, options);
            testCase.verifyFalse(docClient.existsDatabase(databaseLink, options));
            docClient.close;
        end


        function testCreateDeleteCollectionRequestOptions(testCase)
            % use request options when creating a collection
            disp('Running testCreateDeleteCollectionRequestOptions');
            disp('Running testCreateDeleteCollection');
            database = azure.documentdb.Database('unittestcosmosdb');
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);
            testCase.verifyTrue(docClient.existsDatabase(databaseLink, options));

            % create a collection with custom RequestOptions, in this case setting
            % the offer throughput
            myCollection = azure.documentdb.DocumentCollection('mycollectionname');
            CollectionOptions = azure.documentdb.RequestOptions();
            CollectionOptions.setOfferThroughput(400);
            collectionResponse = docClient.createCollection(databaseLink, myCollection, CollectionOptions);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testCreateMultiPartitionCollection(testCase)
            % mostly mirrors functionality of createMultiPartitionCollection() in:
            % https://github.com/Azure/azure-documentdb-java/blob/master/documentdb-examples/src/test/java/com/microsoft/azure/documentdb/examples/StoredProcedureSamples.java
            disp('createMultiPartitionCollection');
            % create the database
            database = azure.documentdb.Database('unittestcosmosdb');
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create the collection
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionId = 'mycollectionname';
            collectionDefinition.setId(collectionId);

            % set /city as the partition key path
            partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
            partitionKeyFieldName = 'city';
            partitionKeyPath = ['/' , partitionKeyFieldName];
            paths = [string(partitionKeyPath)];
            partitionKeyDefinition.setPaths(paths);
            collectionDefinition.setPartitionKey(partitionKeyDefinition);

            % set indexing policy to be range range for string and number
            indexingPolicy = azure.documentdb.IndexingPolicy();
            includedPath = azure.documentdb.IncludedPath();
            includedPath.setPath('/*');
            stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
            numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
            indexes = {stringRangeIndex, numberRangeIndex};
            includedPath.setIndexes(indexes);
            includedPaths = {includedPath};
            indexingPolicy.setIncludedPaths(includedPaths);
            collectionDefinition.setIndexingPolicy(indexingPolicy);

            % create the collection
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % cleanup
            % delete the collection
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);
            docClient.deleteCollection(collectionLink, options);

            % delete the database
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testRangeIndex(testCase)
            disp('testRangeIndex');
            database = azure.documentdb.Database('unittestcosmosdb');
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create the collection
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionId = 'mycollectionname';
            collectionDefinition.setId(collectionId);

            % set indexing policy to be range range for string and number
            indexingPolicy = azure.documentdb.IndexingPolicy();
            includedPath = azure.documentdb.IncludedPath();
            includedPath.setPath('/*');

            % exercise setPrecision, setDataType & RangeIndex
            stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
            numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number);
            numberRangeIndex.setDataType(azure.documentdb.DataType.Number);
            numberRangeIndex.setPrecision(-1);
            indexes = {stringRangeIndex,numberRangeIndex};
            includedPath.setIndexes(indexes);
            includedPaths = {includedPath};
            indexingPolicy.setIncludedPaths(includedPaths);
            collectionDefinition.setIndexingPolicy(indexingPolicy);

            % create the collection
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % delete the collection
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);
            docClient.deleteCollection(collectionLink, options);

            % delete the database
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testStoredProcedures(testCase)
            % mostly mirrors functionality in
            % https://github.com/Azure/azure-documentdb-java/blob/master/documentdb-examples/src/test/java/com/microsoft/azure/documentdb/examples/StoredProcedureSamples.java
            disp('testStoredProcedures');
            % create the database
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create the collection
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionId = 'mycollectionname';
            collectionDefinition.setId(collectionId);

            % set /city as the partition key path
            partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
            partitionKeyFieldName = 'city';
            partitionKeyPath = ['/' , partitionKeyFieldName];
            paths = [string(partitionKeyPath)];
            partitionKeyDefinition.setPaths(paths);
            collectionDefinition.setPartitionKey(partitionKeyDefinition);

            % set indexing policy to be range range for string and number
            indexingPolicy = azure.documentdb.IndexingPolicy();
            includedPath = azure.documentdb.IncludedPath();
            includedPath.setPath('/*');
            stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
            numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
            indexes = {stringRangeIndex,numberRangeIndex};
            includedPath.setIndexes(indexes);
            includedPaths = {includedPath};
            indexingPolicy.setIncludedPaths(includedPaths);
            collectionDefinition.setIndexingPolicy(indexingPolicy);

            % create the collection
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % create a stored procedure
            % For test purposes here we define the JavaScript code inside the
            % test code as a string. In real world cases it would be better to
            % read it from a plain JavaScript file directly to a MATLAB character
            % vector value
            storedProcedureStr = ['{' ,...
                '  "id" : "storedProcedureSample",' ,...
                '  "body" : ',...
                '    "function() {' ,...
                '        var mytext = \"x\";' ,...
                '        var myval = 1;' ,...
                '        try {' ,...
                '            console.log(\"The value of %s is %s.\", mytext, myval);' ,...
                '            getContext().getResponse().setBody(\"Success!\");' ,...
                '        }' ,...
                '        catch(err) {' ,...
                '            getContext().getResponse().setBody(\"inline err: [\" + err.number + \"] \" + err);' ,...
                '        }' ,...
                '     }"',...
                '}'];

            % An alternative and less error prone way to specify the procedure is as a MATLAB struct
            % that is then jsonencoded by MATLAB, note fewer brackets and special character escaping
            % storedProcedureStruct.id = 'storedProcedureSample'
            % storedProcedureStruct.body = ['function() {' ,...
            %    '        var mytext = "x";' ,...
            %    '        var myval = 1;' ,...
            %    '        try {' ,...
            %    '            console.log("The value of %s is %s.", mytext, myval);' ,...
            %    '            getContext().getResponse().setBody("Success!");' ,...
            %    '        }' ,...
            %    '        catch(err) {' ,...
            %    '            getContext().getResponse().setBody("inline err: [" + err.number + "] " + err);' ,...
            %    '        }' ,...
            %    '     }']
            % storedProcedureStr = jsonencode(storedProcedureStruct)

            storedProcedure =  azure.documentdb.StoredProcedure(storedProcedureStr);
            docClient.createStoredProcedure(collectionLink, storedProcedure, options);
            storedProcLink = ['/dbs/',databaseId,'/colls/', collectionId,'/sprocs/','storedProcedureSample'];
            requestOptions = azure.documentdb.RequestOptions();
            requestOptions.setScriptLoggingEnabled(true);
            requestOptions.setPartitionKey(azure.documentdb.PartitionKey('Galway'));

            storedProcedureResponse = docClient.executeStoredProcedure(storedProcLink, requestOptions, {});
            logResult = 'The value of x is 1.';
            testCase.verifyEqual(storedProcedureResponse.getScriptLog(), logResult);
            responseHeadersMap = storedProcedureResponse.getResponseHeaders();
            headerLogResult = responseHeadersMap('x-ms-documentdb-script-log-results');
            % will be returned with spaces mapped to %20's, fix before comparison
            headerLogResult = urldecode(headerLogResult);
            testCase.verifyEqual(headerLogResult, logResult);

            % Execute a Stored Procedure with arguments
            storedProcedureStr2 = ['{' ,...
                '  "id" : "multiplySample",' ,...
                '  "body" : ' ,...
                '    "function (value, num) {' ,...
                '       getContext().getResponse().setBody(\"2*\" + value + \" is \" + num * 2);' ,...
                '     }"' ,...
                '}'];
            storedProcedure2 =  azure.documentdb.StoredProcedure(storedProcedureStr2);
            docClient.createStoredProcedure(collectionLink, storedProcedure2, options);
            requestOptions = azure.documentdb.RequestOptions();
            requestOptions.setPartitionKey(azure.documentdb.PartitionKey('Galway'));
            storedProcLink2 = ['/dbs/',databaseId,'/colls/', collectionId,'/sprocs/','multiplySample'];
            storedProcedureArgs = {"a", 123};
            storedProcedureResponse2 = docClient.executeStoredProcedure(storedProcLink2, requestOptions, storedProcedureArgs);
            storedProcedureResponseStr = storedProcedureResponse2.getResponseAsString();
            testCase.verifyEqual(storedProcedureResponseStr, '"2*a is 246"');

            % cleanup
            % delete the collection & database
            docClient.deleteCollection(collectionLink, options);
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testcreateDocumentAndReadAndDelete(testCase)
            % mostly mirrors functionality of createMultiPartitionCollection() in
            % https://github.com/Azure/azure-documentdb-java/blob/master/documentdb-examples/src/test/java/com/microsoft/azure/documentdb/examples/DocumentCrudSamples.java            disp('createMultiPartitionCollection');
            % create the multi partition collection
            disp('testcreateDocumentAndReadAndDelete');
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create the collection
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionId = 'mycollectionname';
            collectionDefinition.setId(collectionId);

            % set /city as the partition key path
            partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
            partitionKeyFieldName = 'city';
            partitionKeyPath = ['/' , partitionKeyFieldName];
            paths = string(partitionKeyPath);
            partitionKeyDefinition.setPaths(paths);
            collectionDefinition.setPartitionKey(partitionKeyDefinition);

            % set indexing policy to be range range for string and number
            indexingPolicy = azure.documentdb.IndexingPolicy();
            includedPath = azure.documentdb.IncludedPath();
            includedPath.setPath('/*');
            stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
            numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
            indexes = {stringRangeIndex,numberRangeIndex};
            includedPath.setIndexes(indexes);
            includedPaths = {includedPath};
            indexingPolicy.setIncludedPaths(includedPaths);
            collectionDefinition.setIndexingPolicy(indexingPolicy);

            % create the collection
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % create a document in the collection
            % in real world situations the document contents would be read into
            % a variable from a file
            documentContents = ['{' ,...
                        '   "id": "test-document",' ,...
                        '   "city" : "Galway",' ,...
                        '   "population" : 79934', ' }' ] ;
            documentDefinition = azure.documentdb.Document(documentContents);
            disableAutomaticIdGeneration = false;
            documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);

            % access request charge associated with document create
            testCase.verifyGreaterThan(documentResponse.getRequestCharge(), 0.0);
            documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];

            % since it is a Point Read and the collection is multi partition collection, partition key has to be provided
            options = azure.documentdb.RequestOptions();
            options.setPartitionKey(azure.documentdb.PartitionKey('Galway'));

            % read document using the collectionlink and the provided partition key
            response = docClient.readDocument(documentLink, options);

            % access request charge associated with document read
            testCase.verifyGreaterThan(response.getRequestCharge(), 0.0);

            % access individual fields
            readDocument = response.getResource();
            testCase.verifyEqual(readDocument.getId(), 'test-document');
            testCase.verifyEqual(readDocument.getInt('population'), int32(79934));
            testCase.verifyEqual(readDocument.getString('city'), 'Galway');

            % delete document
            response = docClient.deleteDocument(documentLink, options);
            testCase.verifyGreaterThan(response.getRequestCharge(), 0);

            % cleanup delete the database
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testDocumentQuery(testCase)
            % mostly mirrors functionality of DocumentQuerySamples() in
            % https://github.com/Azure/azure-documentdb-java/blob/master/documentdb-examples/src/test/java/com/microsoft/azure/documentdb/examples/DocumentQuerySamples.java
            % create the multi partition collection
            disp('testDocumentQuery');
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create the collection
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionId = 'mycollectionname';
            collectionDefinition.setId(collectionId);

            % set /city as the partition key path
            partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
            partitionKeyFieldName = 'city';
            partitionKeyPath = ['/' , partitionKeyFieldName];
            paths = [string(partitionKeyPath)];
            partitionKeyDefinition.setPaths(paths);
            collectionDefinition.setPartitionKey(partitionKeyDefinition);

            % set indexing policy to be range range for string and number
            indexingPolicy = azure.documentdb.IndexingPolicy();
            includedPath = azure.documentdb.IncludedPath();
            includedPath.setPath('/*');
            stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
            numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
            indexes = {stringRangeIndex,numberRangeIndex};
            includedPath.setIndexes(indexes);
            includedPaths = {includedPath};
            indexingPolicy.setIncludedPaths(includedPaths);
            collectionDefinition.setIndexingPolicy(indexingPolicy);

            % create the collection
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % populate documents
            cities = ["Amherst", "Galway", "Redmond", "北京市", "बंगलौर - विकिपीडिया", "شیراز‎‎" ];
            poetNames = ["Emily Elizabeth Dickinson", "Hafez", "Lao Tzu"];
            disableAutomaticIdGeneration = true;
            options = azure.documentdb.RequestOptions();
            m = 5;
            for n = 1:m
                documentDefinition = azure.documentdb.Document();
                documentDefinition.setId(['test-document',num2str(n)]);
                documentDefinition.Handle.set("city", cities{mod(n,numel(cities))+1});
                documentDefinition.Handle.set("count",n);
                documentDefinition.Handle.set("poetName", poetNames{ mod(n,numel(poetNames))+1});
                documentDefinition.Handle.set("popularity", rand);
                docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);
            end

            % simple document query
            % as this is a multi collection enable cross partition query
            % query first using Java handle methods then get results as a cell array
            options = azure.documentdb.FeedOptions();
            options.setEnableCrossPartitionQuery(true);
            disp(' ');
            disp('simple query');
            disp(' ');
            feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
            iteratorJ = feedResponse.Handle.getQueryIterator();
            k = 0;
            while iteratorJ.hasNext()
                d = azure.documentdb.Document(iteratorJ.next());
                disp(['id is ',d.getId()]);
                disp(['city is ',d.getString('city')]);
                disp(['count is ',num2str(d.getInt('count'))]);
                disp(['popularity is ', num2str(d.getDouble('popularity'))]);
                k = k + 1;
            end
            testCase.verifyEqual(k, m);
            disp(' ');
            disp('results as a cell array');
            disp(' ');

            % run query again to get a fresh underlying iterator
            feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
            responseCellArray = feedResponse.getQueryCellArray();
            for n = 1:length(responseCellArray)
                disp(['id is ',responseCellArray{n}.getId()]);
                disp(['city is ',responseCellArray{n}.getString('city')]);
                disp(['count is ',num2str(responseCellArray{n}.getInt('count'))]);
                disp(['popularity is ', num2str(responseCellArray{n}.getDouble('popularity'))]);
            end
            testCase.verifyEqual(length(responseCellArray), m);

            % order by query
            disp(' ');
            disp('order by query');
            disp(' ');
            feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r ORDER BY r.count', options);
            iteratorJ = feedResponse.Handle.getQueryIterator();
            k = 0;
            while iteratorJ.hasNext()
                d = azure.documentdb.Document(iteratorJ.next());
                disp(['id is ',d.getId()]);
                disp(['city is ',d.getString('city')]);
                disp(['count is ',num2str(d.getInt('count'))]);
                disp(['popularity is ', num2str(d.getDouble('popularity'))]);
                k = k + 1;
            end
            testCase.verifyEqual(k, m);

            % cleanup delete the database
            options = azure.documentdb.RequestOptions();
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testOffer(testCase)
            % mostly mirrors functionality of replaceOffer() in:
            % https://github.com/Azure/azure-documentdb-java/blob/master/documentdb-examples/src/test/java/com/microsoft/azure/documentdb/examples/SinglePartitionCollectionDocumentCrudSample.java
            disp('testOffer');
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            options = azure.documentdb.RequestOptions();
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);
            testCase.verifyTrue(docClient.existsDatabase(databaseLink, options));

            % create collection
            collectionId = 'mycollectionname';
            collectionDefinition = azure.documentdb.DocumentCollection(collectionId);

            % set /city as the partition key path
            partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
            partitionKeyPath = "/id";
            partitionKeyDefinition.setPaths(partitionKeyPath);
            collectionDefinition.setPartitionKey(partitionKeyDefinition);

            % if you want a single partition collection with 10,000 throughput
            % the only way to do so is to create a single partition collection with lower throughput (400)
            % and then increase the throughput to 10,000
            CollectionOptions = azure.documentdb.RequestOptions();
            originalThroughput = 400;
            CollectionOptions.setOfferThroughput(originalThroughput);

            % create indexes
            indexingPolicy = azure.documentdb.IndexingPolicy();
            includedPath = azure.documentdb.IncludedPath();
            includedPath.setPath('/*');
            stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
            numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
            indexes = {stringRangeIndex,numberRangeIndex};
            includedPath.setIndexes(indexes);
            includedPaths = {includedPath};
            indexingPolicy.setIncludedPaths(includedPaths);
            collectionDefinition.setIndexingPolicy(indexingPolicy);

            % create the collection
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, CollectionOptions);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % run the query
            queryStr = ['SELECT * FROM c where c.offerResourceId = ''', documentCollection.getResourceId(),''''];
            feedOptions = azure.documentdb.FeedOptions();
            offersFeedResponse = docClient.queryOffers(queryStr, feedOptions);
            offerIteratorJ = offersFeedResponse.Handle.getQueryIterator();
            testCase.verifyTrue(offerIteratorJ.hasNext());

            % check the offer
            offer = azure.documentdb.Offer(offerIteratorJ.next());
            % returns a Java JSON object
            contentJSON = offer.getContent();
            offerThroughput = int32(contentJSON.getInt('offerThroughput'));
            testCase.verifyEqual(offerThroughput, int32(originalThroughput));

            % reset the offer value
            desiredThroughput = int32(600);
            contentJSON.put('offerThroughput', desiredThroughput);
            offer.setContent(contentJSON);
            newOfferResponse = docClient.replaceOffer(offer);
            newOffer = newOfferResponse.getResource();
            contentJSON = newOffer.getContent();
            newOfferThroughput = int32(contentJSON.getInt('offerThroughput'));
            testCase.verifyEqual(desiredThroughput, newOfferThroughput);

            % cleanup delete the database
            options = azure.documentdb.RequestOptions();
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testTriggerCreateQueryRead(testCase)
            disp('testTriggerCreateQueryRead');
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            options = azure.documentdb.RequestOptions();
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create collection
            collectionId = 'mycollectionname';
            collectionDefinition = azure.documentdb.DocumentCollection(collectionId);
            CollectionOptions = azure.documentdb.RequestOptions();
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, CollectionOptions);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % create trigger, in real world situations the trigger body would be
            % read into the variable from a file
            triggerId = 'mytriggerexample';
            trigger = azure.documentdb.Trigger();
            trigger.setId(triggerId);
            triggerBody = ['function testTrigger() {',...
                ' var context = getContext();' ,...
                ' var request = context.getRequest();' ,...
                ' var myDocument = request.getBody();' ,...
                ' myDocument["myTest"] = "Created by createTrigger";' ,...
                ' request.setBody(myDocument);' ,...
            '}'];
            trigger.setBody(triggerBody);
            trigger.setTriggerType(azure.documentdb.TriggerType.Pre);
            trigger.setTriggerOperation(azure.documentdb.TriggerOperation.Delete);
            docClient.createTrigger(collectionLink, trigger, options);

            % verify create trigger happened
            feedOptions = azure.documentdb.FeedOptions();
            queryStr = ['SELECT * FROM r where r.id = ''', triggerId,''''];
            queryResults = docClient.queryTriggers(collectionLink, queryStr, feedOptions);
            responseCellArray = queryResults.getQueryCellArray();
            testCase.verifyTrue(isa(responseCellArray{1},'azure.documentdb.Trigger'));
            testCase.verifyEqual(responseCellArray{1}.getId, triggerId);

            % read the trigger
            triggerLink = ['/dbs/',databaseId,'/colls/',collectionId,'/triggers/',triggerId];
            readResponse = docClient.readTrigger(triggerLink, options);
            readTrigger = readResponse.getResource();
            testCase.verifyEqual(readTrigger.getId, triggerId);
            testCase.verifyEqual(readTrigger.getBody, triggerBody);

            % delete the trigger
            deleteResponse = docClient.deleteTrigger(triggerLink, options);

            % cleanup delete the database
            options = azure.documentdb.RequestOptions();
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testAttachmentCreateReadDeleteQuery(testCase)
            disp('testAttachmentCreateReadDeleteQuery');
            % create database
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            options = azure.documentdb.RequestOptions();
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create collection in the database
            collectionId = 'mycollectionname';
            collectionDefinition = azure.documentdb.DocumentCollection(collectionId);
            CollectionOptions = azure.documentdb.RequestOptions();
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, CollectionOptions);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();

            % create a document in the collection
            documentContents = ['{' ,...
                        '   "id": "test-document",' ,...
                        '   "city" : "Galway",' ,...
                        '   "population" : 79934', ' }' ] ;
            documentDefinition = azure.documentdb.Document(documentContents);
            disableAutomaticIdGeneration = false;
            documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration); %#ok<NASGU>
            documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];

            % create an attachment
            body.id = 'image_id';
            body.contentType = 'image/jpg';
            body.media = 'www.mathworks.com';
            attachment = azure.documentdb.Attachment(jsonencode(body));
            attachmentResponse = docClient.createAttachment(documentLink, attachment, options);
            attachmentResource = attachmentResponse.getResource();
            testCase.verifyTrue(isa(attachmentResource,'azure.documentdb.Attachment'));
            testCase.verifyEqual(attachmentResource.getId(), 'image_id');

            % use alternate methods to create a 2nd attachment
            attachment2 = azure.documentdb.Attachment();
            attachment2.setId('myId2');
            attachment2.setMediaLink('www.mathworks.com');
            attachment2.setContentType('text/plain');
            attachmentResponse2 = docClient.createAttachment(documentLink, attachment2, options);
            attachmentResource2 = attachmentResponse2.getResource();
            testCase.verifyTrue(isa(attachmentResource2,'azure.documentdb.Attachment'));
            testCase.verifyEqual(attachmentResource2.getId(), attachment2.getId());
            testCase.verifyEqual(attachmentResource2.getMediaLink(), attachment2.getMediaLink());
            testCase.verifyEqual(attachmentResource2.getContentType(), attachment2.getContentType());

            % read 2nd attachment
            attachmentLink2 = attachmentResource2.getSelfLink();
            readResponse = docClient.readAttachment(attachmentLink2, options);
            readAttachment = readResponse.getResource();
            testCase.verifyEqual(readAttachment.getId(), attachment2.getId());

            % read both attachments
            feedOptions = azure.documentdb.FeedOptions();
            readResponses = docClient.readAttachments(documentLink, feedOptions);
            responseCellArray = readResponses.getQueryCellArray();
            testCase.verifyEqual(length(responseCellArray), 2);
            testCase.verifyTrue(isa(responseCellArray{1},'azure.documentdb.Attachment'));
            testCase.verifyTrue(strcmp(responseCellArray{1}.getId(), attachment2.getId()) || strcmp(responseCellArray{1}.getId(), attachmentResource.getId()));
            testCase.verifyTrue(strcmp(responseCellArray{2}.getId(), attachment2.getId()) || strcmp(responseCellArray{2}.getId(), attachmentResource.getId()));

            % delete 2nd attachment
            docClient.deleteAttachment(attachmentLink2, options);

            % query remaining attachments
            feedResponse = docClient.queryAttachments(documentLink, 'SELECT * from r', feedOptions);
            responseCellArray = feedResponse.getQueryCellArray();
            testCase.verifyEqual(length(responseCellArray), 1);
            testCase.verifyTrue(isa(responseCellArray{1},'azure.documentdb.Attachment'));

            % cleanup delete the database
            options = azure.documentdb.RequestOptions();
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testDocumentUpsert(testCase)
            disp('testDocumentUpsert');
            % create database
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            options = azure.documentdb.RequestOptions();
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create collection in the database
            collectionId = 'mycollectionname';
            collectionDefinition = azure.documentdb.DocumentCollection(collectionId);
            CollectionOptions = azure.documentdb.RequestOptions();
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, CollectionOptions);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();

            % create a document in the collection
            documentContents = ['{' ,...
                        '   "id": "test-document",' ,...
                        '   "city" : "Galway",' ,...
                        '   "population" : 79934', ' }' ] ;
            documentDefinition = azure.documentdb.Document(documentContents);
            disableAutomaticIdGeneration = false;

            % upsert the doc to the database
            documentResponse = docClient.upsertDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);

            % read document and verify properties
            documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
            response = docClient.readDocument(documentLink, options);

            % access request charge associated with document read
            testCase.verifyGreaterThan(response.getRequestCharge(), 0.0);

            % access individual fields
            readDocument = response.getResource();
            testCase.verifyEqual(readDocument.getId(), 'test-document');
            testCase.verifyEqual(readDocument.getInt('population'), int32(79934));
            testCase.verifyEqual(readDocument.getString('city'), 'Galway');

            % cleanup delete the database
            options = azure.documentdb.RequestOptions();
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testAttachmentUpsert(testCase)
            disp('testAttachmentUpsert');
            % create database
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            options = azure.documentdb.RequestOptions();
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create collection in the database
            collectionId = 'mycollectionname';
            collectionDefinition = azure.documentdb.DocumentCollection(collectionId);
            CollectionOptions = azure.documentdb.RequestOptions();
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, CollectionOptions);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();

            % create a document in the collection
            documentContents = ['{' ,...
                        '   "id": "test-document",' ,...
                        '   "city" : "Galway",' ,...
                        '   "population" : 79934', ' }' ] ;
            documentDefinition = azure.documentdb.Document(documentContents);
            disableAutomaticIdGeneration = false;
            documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration); %#ok<NASGU>
            documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];

            % create attachment
            body.id = 'image_id';
            body.contentType = 'image/jpg';
            body.media = 'www.mathworks.com';
            attachment = azure.documentdb.Attachment(jsonencode(body));
            attachmentResponse = docClient.upsertAttachment(documentLink, attachment, options);
            attachmentResource = attachmentResponse.getResource();
            testCase.verifyTrue(isa(attachmentResource,'azure.documentdb.Attachment'));
            testCase.verifyEqual(attachmentResource.getId(), 'image_id');

            % cleanup delete the database
            options = azure.documentdb.RequestOptions();
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testStoredProceduresQueryRead(testCase)
            disp('testStoredProceduresQueryRead');
            % create the database
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create the collection
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionId = 'mycollectionname';
            collectionDefinition.setId(collectionId);

            % set /city as the partition key path
            partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
            partitionKeyFieldName = 'city';
            partitionKeyPath = ['/' , partitionKeyFieldName];
            paths = [string(partitionKeyPath)];
            partitionKeyDefinition.setPaths(paths);
            collectionDefinition.setPartitionKey(partitionKeyDefinition);

            % set indexing policy to be range range for string and number
            indexingPolicy = azure.documentdb.IndexingPolicy();
            includedPath = azure.documentdb.IncludedPath();
            includedPath.setPath('/*');
            stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
            numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
            indexes = {stringRangeIndex,numberRangeIndex};
            includedPath.setIndexes(indexes);
            includedPaths = {includedPath};
            indexingPolicy.setIncludedPaths(includedPaths);
            collectionDefinition.setIndexingPolicy(indexingPolicy);

            % create the collection
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % create a stored procedure, normally read this from a file
            % to avoid escaping
            storedProcedureStr = ['{' ,...
                '  "id" : "storedProcedureSample",' ,...
                '  "body" : ',...
                '    "function() {' ,...
                '        var mytext = \"x\";' ,...
                '        var myval = 1;' ,...
                '        try {' ,...
                '            console.log(\"The value of %s is %s.\", mytext, myval);' ,...
                '            getContext().getResponse().setBody(\"Success!\");' ,...
                '        }' ,...
                '        catch(err) {' ,...
                '            getContext().getResponse().setBody(\"inline err: [\" + err.number + \"] \" + err);' ,...
                '        }' ,...
                '     }"',...
                '}'];
            storedProcedure =  azure.documentdb.StoredProcedure(storedProcedureStr);
            docClient.createStoredProcedure(collectionLink, storedProcedure, options);
            storedProcLink = ['/dbs/',databaseId,'/colls/', collectionId,'/sprocs/','storedProcedureSample'];
            requestOptions = azure.documentdb.RequestOptions();
            requestOptions.setScriptLoggingEnabled(true);
            requestOptions.setPartitionKey(azure.documentdb.PartitionKey('Galway'));

            % run the stored procedure
            storedProcedureResponse = docClient.executeStoredProcedure(storedProcLink, requestOptions, {});
            logResult = 'The value of x is 1.';
            testCase.verifyEqual(storedProcedureResponse.getScriptLog(), logResult);
            responseHeadersMap = storedProcedureResponse.getResponseHeaders();
            headerLogResult = responseHeadersMap('x-ms-documentdb-script-log-results');
            % will be returned with spaces mapped to %20's, fix before comparison
            headerLogResult = urldecode(headerLogResult);
            testCase.verifyEqual(headerLogResult, logResult);

            % execute Stored Procedure with arguments
            storedProcedureStr2 = ['{' ,...
                '  "id" : "multiplySample",' ,...
                '  "body" : ' ,...
                '    "function (value, num) {' ,...
                '       getContext().getResponse().setBody(\"2*\" + value + \" is \" + num * 2);' ,...
                '     }"' ,...
                '}'];
            storedProcedure2 =  azure.documentdb.StoredProcedure(storedProcedureStr2);
            docClient.createStoredProcedure(collectionLink, storedProcedure2, options);
            requestOptions = azure.documentdb.RequestOptions();
            requestOptions.setPartitionKey(azure.documentdb.PartitionKey('Galway'));
            storedProcLink2 = ['/dbs/',databaseId,'/colls/', collectionId,'/sprocs/','multiplySample'];
            storedProcedureArgs = {"a", 123};
            storedProcedureResponse2 = docClient.executeStoredProcedure(storedProcLink2, requestOptions, storedProcedureArgs);
            storedProcedureResponseStr = storedProcedureResponse2.getResponseAsString();
            testCase.verifyEqual(storedProcedureResponseStr, '"2*a is 246"');

            % stored procedures have been created and tested now query them
            procId = storedProcedure.getId();
            feedOptions = azure.documentdb.FeedOptions();
            queryStr = ['SELECT * FROM r where r.id = ''', procId,''''];
            queryResults = docClient.queryStoredProcedures(collectionLink, queryStr, feedOptions);
            iterator = queryResults.Handle.getQueryIterator();
            testCase.verifyTrue(iterator.hasNext());
            foundQueryJ = azure.documentdb.StoredProcedure(iterator.next());
            testCase.verifyEqual(char(foundQueryJ.getId()), storedProcedure.getId());

            % read a single procedure
            % reset requestOptions as we no longer want the partitionKey set
            requestOptions = azure.documentdb.RequestOptions();
            readResponse = docClient.readStoredProcedure(storedProcLink, requestOptions);
            readResult = readResponse.getResource();
            testCase.verifyEqual(char(readResult.getId()), storedProcedure.getId());

            % read all procedures
            feedResponse = docClient.readStoredProcedures(collectionLink, feedOptions);
            responseCellArray = feedResponse.getQueryCellArray();
            testCase.verifyEqual(length(responseCellArray), 2);
            testCase.verifyTrue(isa(responseCellArray{1},'azure.documentdb.StoredProcedure'));
            testCase.verifyEqual(char(responseCellArray{1}.getId()), storedProcedure.getId());

            % delete the storedProcedure
            deleteResponse = docClient.deleteStoredProcedure(storedProcLink, requestOptions);

            % cleanup
            % delete the collection & database
            docClient.deleteCollection(collectionLink, options);
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testUserDefinedFunctionsQueryRead(testCase)
            % mostly mirrors udf functionality of shown in:
            % https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-write-stored-procedures-triggers-udfs
            % https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-use-stored-procedures-triggers-udfs#udfs
            disp('testUserDefinedFunctionsQueryRead');

            % create the database
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create the collection
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionDefinition.setId('Incomes');
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % create a document
            documentContents = ['{ '...
            '"name" : "Joe Blog", '...
            '"country" : "USA", '...
            '"income" : 70000'...
            '}'];
            documentDefinition = azure.documentdb.Document(documentContents);
            disableAutomaticIdGeneration = false;
            documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);
            testCase.verifyGreaterThan(documentResponse.getRequestCharge(), 0.0);

            % the JavaScript code the UDF runs, normally read this from a file
            jsCode = ['function tax(income) { '...
                        'if(income == undefined) '...
                        '  throw ''no input''; '...
                        'if (income < 1000) '...
                        '  return income * 0.1; ' ...
                        'else if (income < 10000) '...
                        '  return income * 0.2; '...
                        'else '...
                        '  return income * 0.4; '...
                     '}'];
            myUDF = azure.documentdb.UserDefinedFunction();
            myUDF.setId('udfTax');
            myUDF.setBody(jsCode);

            % create a collectionLink and then the UDF
            containerLink = ['/dbs/',databaseId,'/colls/','Incomes'];
            createdUDF = docClient.createUserDefinedFunction(collectionLink, myUDF, options);

            % query the UDF
            feedOptions = azure.documentdb.FeedOptions();
            feedResponse = docClient.queryUserDefinedFunctions(collectionLink, 'SELECT * from r', feedOptions);
            responseCellArray = feedResponse.getQueryCellArray();
            testCase.verifyEqual(char(responseCellArray{1}.getId()), myUDF.getId());

            % read the UDF
            udfLink = [containerLink, '/', 'udfs/',myUDF.getId()];
            readResponse = docClient.readUserDefinedFunction(udfLink, options);
            readResult = readResponse.getResource();
            testCase.verifyEqual(char(readResult.getId()), myUDF.getId());

            % test the UDF's existence, via a wrapped read
            tf = docClient.existsUserDefinedFunction(udfLink, options);
            testCase.verifyTrue(tf);

            % read all UDFs
            feedResponse = docClient.readUserDefinedFunctions(collectionLink, feedOptions);
            responseCellArray = feedResponse.getQueryCellArray();
            testCase.verifyEqual(char(responseCellArray{1}.getId()), myUDF.getId());

            % invoke the UDF
            feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * FROM Incomes t WHERE udf.udfTax(t.income) > 20000', feedOptions);
            responseCellArray = feedResponse.getQueryCellArray();
            testCase.verifyEqual(char(responseCellArray{1}.getString('name')), 'Joe Blog');
            testCase.verifyEqual(char(responseCellArray{1}.getString('country')), 'USA');
            testCase.verifyEqual(responseCellArray{1}.getInt('income'), int32(70000));

            % delete the UDF
            deleteResponse = docClient.deleteUserDefinedFunction(udfLink, options);
            tf = docClient.existsUserDefinedFunction(udfLink, options);
            testCase.verifyFalse(tf);

            % cleanup
            % delete the collection & database
            docClient.deleteCollection(collectionLink, options);
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testDocumentsRead(testCase)
            % mostly mirrors udf functionality of shown in:
            % https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-write-stored-procedures-triggers-udfs
            % https://docs.microsoft.com/en-us/azure/cosmos-db/how-to-use-stored-procedures-triggers-udfs#udfs
            disp('testDocumentsRead');

            % create the database
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            options = azure.documentdb.RequestOptions();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create the collection
            collectionDefinition = azure.documentdb.DocumentCollection();
            collectionId = 'Incomes';
            collectionDefinition.setId(collectionId);
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();
            testCase.verifyTrue(ischar(collectionLink));
            testCase.verifyNotEmpty(collectionLink);

            % create a document
            documentContents = ['{ '...
            '"id": "test-document",' ,...
            '"name" : "Joe Blog", '...
            '"country" : "USA", '...
            '"income" : 70000'...
            '}'];
            documentDefinition = azure.documentdb.Document(documentContents);
            disableAutomaticIdGeneration = false;
            documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);
            testCase.verifyGreaterThan(documentResponse.getRequestCharge(), 0.0);

            % read the document
            documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
            response = docClient.readDocument(documentLink, options);
            readDocument = response.getResource();
            testCase.verifyEqual(readDocument.getInt('income'), int32(70000));
            testCase.verifyEqual(readDocument.getString('country'), 'USA');

            % read all documents
            feedOptions = azure.documentdb.FeedOptions();
            feedResponse = docClient.readDocuments(collectionLink, feedOptions);
            responseCellArray = feedResponse.getQueryCellArray();
            testCase.verifyEqual(char(responseCellArray{1}.getString('name')), 'Joe Blog');
            testCase.verifyEqual(char(responseCellArray{1}.getString('country')), 'USA');
            testCase.verifyEqual(responseCellArray{1}.getInt('income'), int32(70000));

            % cleanup
            % delete the collection & database
            docClient.deleteCollection(collectionLink, options);
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end


        function testAttachmentFromFile(testCase)
            disp('testAttachmentFromFile');
            % create database
            databaseId = 'unittestcosmosdb';
            database = azure.documentdb.Database(databaseId);
            options = azure.documentdb.RequestOptions();
            databaseLink = ['/dbs/',database.getId()];
            docClient = azure.documentdb.DocumentClient();
            if docClient.existsDatabase(databaseLink, options)
                docClient.deleteDatabase(databaseLink, options);
            end
            docClient.createDatabase(database, options);

            % create collection in the database
            collectionId = 'mycollectionname';
            collectionDefinition = azure.documentdb.DocumentCollection(collectionId);
            CollectionOptions = azure.documentdb.RequestOptions();
            collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, CollectionOptions);
            documentCollection = collectionResponse.getResource();
            collectionLink = documentCollection.getSelfLink();

            % create a document in the collection
            documentContents = ['{' ,...
                        '   "id": "test-document",' ,...
                        '   "city" : "Galway",' ,...
                        '   "population" : 79934', ' }' ] ;
            documentDefinition = azure.documentdb.Document(documentContents);
            disableAutomaticIdGeneration = false;
            documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration); %#ok<NASGU>
            documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];

            % create sample data file
            data = rand(10);
            tmpName = tempname;
            dlmwrite(tmpName, data);

            % create attachment
            mOptions = azure.documentdb.MediaOptions();
            slug = 'myAttachmentId';
            % write the data in ascii format
            contentType = 'text/plain';
            mOptions.setSlug(slug);
            mOptions.setContentType(contentType);
            testCase.verifyEqual(mOptions.getSlug(), slug);
            testCase.verifyEqual(mOptions.getContentType(), contentType);
            attachmentResponse = docClient.createAttachment(documentLink, tmpName, mOptions);

            % no longer need the temp file so delete it
            delete(tmpName);
            attachmentResource = attachmentResponse.getResource();
            testCase.verifyTrue(isa(attachmentResource,'azure.documentdb.Attachment'));
            testCase.verifyEqual(attachmentResource.getId(), slug);

            % read back the attachment
            attachmentLink = attachmentResource.getSelfLink();
            readResponse = docClient.readAttachment(attachmentLink, options);
            readAttachment = readResponse.getResource();
            testCase.verifyEqual(readAttachment.getId(), slug);
            testCase.verifyEqual(readAttachment.getContentType(), contentType);

            % get the mediaLink check the headers and get the content
            mediaLink = readAttachment.getMediaLink();
            mediaResponse = docClient.readMedia(mediaLink);
            headers = mediaResponse.getResponseHeaders();
            testCase.verifyEqual(headers('Content-Type'), contentType);
            tmpOutput = tempname;
            tf = mediaResponse.getMedia(tmpOutput);
            testCase.verifyTrue(tf);
            attachedData = dlmread(tmpOutput);
            delete(tmpOutput);
            testCase.verifyEqual(data(1,1), attachedData(1,1), 'AbsTol',0.0001);
            testCase.verifyEqual(data(10,10), attachedData(10,10), 'AbsTol',0.0001);

            % cleanup delete the database
            options = azure.documentdb.RequestOptions();
            docClient.deleteDatabase(databaseLink, options);
            docClient.close;
        end

    end % methods
end % class
