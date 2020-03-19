# MATLAB Interface *for Azure Cosmos DB* - SQL API

## Getting Started
The Cosmos DB SQL API supported by this package builds upon the Microsoft Java SDK for the Cosmos DB SQL API. Further details on Cosmos DB and the SQL SDK can be found here: [https://docs.microsoft.com/en-us/azure/cosmos-db/introduction](https://docs.microsoft.com/en-us/azure/cosmos-db/introduction)

This document is a basic guide to using the Interface and does not describe Cosmos DB itself or all of the supported operations. Further details can be found in the [API reference document](ApiRefSQL.md). The provided test suite */Software/MATLAB/SQL/test/unit/testDocumentDb.m* can also serve as a reference. For information on accessing Cosmos DB via APIs other than SQL, e.g. Table, see the respective documentation.

## Create a Cosmos DB SQL API account
Before using SQL API, create a Cosmos DB account with SQL API specified as the interface. The necessary steps can be found here: [https://docs.microsoft.com/en-us/azure/cosmos-db/create-sql-api-java](https://docs.microsoft.com/en-us/azure/cosmos-db/create-sql-api-java)

Note the account name and key as they will be required to authenticate the client to Cosmos DB. By default the interface searches the path for a file containing these values called: *documentdb.json*. It should have the following structure:
```
{
   "serviceEndpoint" : "https://<my-Azure-Cosmos-DB-account-name>.documents.azure.com:443/",
   "masterKey" : "p6<my-redacted-key>Q=="
}
```
An alternative file name or specific values can be provided when creating a *DocumentClient()*, if preferred. These values should be should be kept securely.

## Connect to Cosmos DB
A *DocumentClient()* object is primarily used to connect to Cosmos DB, this is created as follows:
```
docClient = azure.documentdb.DocumentClient();
```
This assumes that credentials are read in the default manner, as previously described. When no longer needed it is good practice to close the client.
```
docClient.close;
```

When working with Cosmos DB databases, particularly during development, it is useful to open the [Azure portal](https://portal.azure.com). The portal interface provides a GUI based view of the contents of your databases and basic editing features.

When creating the client the consistency level the client will seek to apply can be set. The default level is *Session*.
```
% use Strong consistency
myConsistencyLevel = azure.documentdb.ConsistencyLevel.Strong;
docClient = azure.documentdb.DocumentClient('consistencyLevel', myConsistencyLevel);
```

A client connection policy can also be configured. This enables the use of a network proxy.
See: [Network Configuration](NetworkConfiguration.md) for more details.
```
myConnectionPolicy = azure.documentdb.ConnectionPolicy();
myConnectionPolicy.setProxy('http://proxy.example.com:3128');
docClient = azure.documentdb.DocumentClient('connectionPolicy', myConnectionPolicy)
```

## Supported Features
This document does not describe all features or methods supported by the interface. Further details can be found in the [API reference document](CosmosDBSQLApi.md). Furthermore this interface does not support all features offered by the underlying SDK. However, it is extensible if additional SDK supported functionality is required. Should you need additional functionality please contact MathWorks as described in [README.md](../README.md).

The following are the main features of the interface:
* Create, read, query & delete Databases
* Create, read, query & delete Collections
* Create, read, query, update & delete Documents
* Create, read, query, update & delete Attachments
* Create, read, query, execute & delete Stored Procedures
* Create, read, query, execute & delete User Defined Functions
* Create, read, query, & delete Triggers
* Create, query and replace Offers


## Creating a Cosmos DB SQL database
The follow code creates a database, assuming it does not already exist.
```
% create a document client
docClient = azure.documentdb.DocumentClient();

% configure the data database ID and standard options
database = azure.documentdb.Database('mytestdatabase');
options = azure.documentdb.RequestOptions();

% create the database using the client
docClient.createDatabase(database, options);

% create a database link to read back the database to verify creation
databaseLink = ['/dbs/',database.getId()];
readResponse = docClient.readDatabase(databaseLink, options);
databaseResult = readResponse.getResource();

% The following calls to the resulting database and the database object used
% to create it should return the the database Id: 'mytestdatabase'
databaseResult.getId()
database.getId()

% close the client when finished, note the database remains in existence
% and will result in charges to the Azure account in question unless deleted
docClient.deleteDatabase(databaseLink, options);
docClient.close;
```

## Test Suite
An extensive suite of tests are provided to validate the interface but also to provide a source of basic sample usage code for the interface. In many cases the functionality of the test cases mirrors the functionality of the published [Microsoft Java SDK test cases](https://github.com/Azure/azure-cosmosdb-java/tree/master/sdk/src/test/java/com/microsoft/azure/cosmosdb/rx). The test cases can be found in: [testDocumentDb.m](../Software/SQL/test/unit/testDocumentDb.m). The following is an example taken from the test suite that shows upsert of a document:
```
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
```

## References:
* [Azure Cosmos DB Introduction](https://docs.microsoft.com/en-us/azure/cosmos-db/)
* [Microsoft Sample Document DB Java API usage](https://docs.microsoft.com/en-us/azure/cosmos-db/create-sql-api-java)
* [Document DB Java API reference](https://docs.microsoft.com/en-us/java/api/com.microsoft.azure.documentdb?view=azure-java-stable)
* [Microsoft Java Tests](https://github.com/Azure/azure-cosmosdb-java/tree/master/sdk/src/test/java/com/microsoft/azure/cosmosdb/rx)

------------
[//]: #  (Copyright 2019, The MathWorks, Inc.)
