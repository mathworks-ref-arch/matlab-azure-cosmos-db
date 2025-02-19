#  MATLAB Interface *for Azure Cosmos DB*

This is a MATLAB® interface that connects to the Microsoft® Azure Cosmos DB™ service.

## Requirements
### MathWorks products
* Requires MATLAB release R2019b or later
* Database Toolbox
  - The MongoDB API is supported directly in Database Toolbox R2019b and later, see below 
* Table API
  - [MATLAB Interface *for Windows Azure Storage Blob*](https://github.com/mathworks-ref-arch/matlab-azure-blob) release 0.7.4 or later, This dependency has been deprecated and is not recommended.

### 3rd party products
To build required JARs files for Gremlin, Table & SQL APIs:
* Maven™
* JDK 8
* Microsoft® Azure Cosmos DB SDK for Java®

## Getting started

Please refer to the documents in the [Documentation](Documentation/README.md) folder to get started. In particular, the Basic Usage guides which provide an overview for using the interface.

Azure Cosmos DB is a globally distributed, multi-model database from Microsoft. Azure Cosmos DB enables you to elastically and independently scale throughput and storage across any number of Azure's geographic regions. It offers throughput, latency, availability, and consistency guarantees with comprehensive service level agreements.

This interface supports four interfaces for Cosmos DB:
  * MongoDB API
    - This package is not required to access the Cosmos DB MonogDB interface in Database Toolbox R2019b or later. Support has been removed in release 0.2.0 and later. For convenience documentation relating to the Database Toolbox support has been [retained and updated](Documentation/BasicUsageMongoDB.md).
  * SQL (DocumentDB) API
  * Table API
  * Gremlin API

The Cassandra API is currently not supported.

## SQL API

This interface uses the original Azure Cosmos DB Sync Java SDK v2 for SQL API which supports synchronous operations.

The following are the main features of the interface:
* Create, read, query & delete Databases
* Create, read, query & delete Collections
* Create, read, query, update & delete Documents
* Create, read, query, update & delete Attachments
* Create, read, query, execute & delete Stored Procedures
* Create, read, query, execute & delete User Defined Functions
* Create, read, query, & delete Triggers
* Create, query and replace Offers

The follow code creates a database, assuming it does not already exist.
```
% create a document client
docClient = azure.documentdb.DocumentClient();

% configure the database Id and standard request options
database = azure.documentdb.Database('mytestdatabase');
options = azure.documentdb.RequestOptions();

% create the database using the client
docClient.createDatabase(database, options);

% create a database link to read back the database to verify creation
databaseLink = ['/dbs/',database.getId()];
readResponse = docClient.readDatabase(databaseLink, options);
databaseResult = readResponse.getResource();

% The following calls to the resulting database and the database object used
% to create it should return the database Id: 'mytestdatabase'
databaseResult.getId()
database.getId()

% close the client when finished, note the database remains in existence
% and will result in charges to the Azure account in question unless deleted
docClient.deleteDatabase(databaseLink, options);
docClient.close;
```

## Table API
The Table API supports the features provided by the Table interface provided by the [MATLAB Interface *for Windows Azure Storage Blob*](https://github.com/mathworks-ref-arch/matlab-azure-blob). This dependency has been deprecated and is not recommended. See: [https://github.com/mathworks-ref-arch/matlab-azure-services](https://github.com/mathworks-ref-arch/matlab-azure-services)

For example when an authenticated CloudStorageAccount object has been created it can be used to create a client which in turn can create table and list table contents as shown.

```
%% Create a *CloudTableClient* object and use it to create a new
% *CloudTable* object which represents a table called *sampletable*.
% A *CloudTable* object is required for most Table operations.
azClient = az.getCloudTableClient();
tableHandle = azure.storage.table.CloudTable(azClient,'sampletable');
tableHandle.createIfNotExists();

% To get a list of tables, call the *CloudTableClient.listTables()* method.
tableList = azClient.listTables

tableList =

  1x14 CloudTable array with properties:

    Parent
    Name
```

## MongoDB API
MongoDB API support requires the installation of the MathWorks Database Toolbox. The Database Toolbox Interface for MongoDB ships with the Database toolbox since R2019b. 

The following sample code connects to a database and inserts some sample data.
```
%% Create connection to Cosmos DB Mongo API
% Use valid values for myusername, mydatabasename, myusername & password
conn = mongo("myusername.documents.azure.com", 10255, "mydatabasename",...
"UserName", "myusername",...
"Password", "sa<REDACTED>Ewg==",...
"AuthMechanism", "SCRAM_SHA_1", "SSLEnabled", true);

% Create a collection
myCollectionName = 'MongoTestCollection';
conn.createCollection(myCollectionName);

% Check if there are anything in the collection already, there should not be
dataCount = count(conn, myCollectionName);

% Create some sample data
LastName = {'Sanchez';'Johnson';'Li';'Diaz';'Brown'};
Age = [38;43;38;40;49];
Smoker = logical([1;0;1;0;1]);
Height = [71;69;64;67;64];
Weight = [176;163;131;133;119];
BloodPressure = [124 93; 109 77; 125 83; 117 75; 122 80];
T = table(LastName,Age,Smoker,Height,Weight,BloodPressure);

% Put the data into MongoDB from the table T
data = conn.insert(myCollectionName, T);

% Close the connection when finished
conn.close();
```

## Gremlin API

The Gremlin API allows you to create and manage an  Microsoft® Azure Cosmos DB™ Gremlin (graph) API account. You will need a Gremlin (Graph) database account with Azure Cosmos DB before you get started. Details on creating a Graph database account can be found [here](https://docs.microsoft.com/en-us/azure/cosmos-db/create-graph-java#create-a-database-account).

The next step would be to configure the credentials for the database account. The credentials need to be placed at the folder location `MATLAB/Gremlin/config` for the API to access them. Please see `gremlindb.yml.template` for reference. Details on accessing credentials from the Azure Cosmos DB Gremlin API account can be found [here](https://docs.microsoft.com/en-us/azure/cosmos-db/create-graph-java#update-your-connection-information).

Once the credentails have been put in place, follow the instructions provided within [Installation](Documentation/Installation.md) to install the API for use. Run the `startup.m` file within `Software/MATLAB/Gremlin` once you have completed the installation steps.

The following sections contain sample code for getting started with the API. A more detailed example is available at [GettingStarted](Documentation/BasicUsageGremlin.md).

### Create a MATLAB client for Azure Cosmos DB Gremlin API
The MATLAB class `GremlinClient` reads credentials from the YAML file located at `MATLAB/Gremlin/config` and returns a MATLAB client object as follows:

```
gClient = azure.gremlin.GremlinClient('gremlindb.yml')
```

### Construct a Gremlin query
Queries need to be defined as strings in MATLAB. You can pass either a single query or multiple queries using a cell array.

```
%  Write a query to drop any existing graph in the sample database
%  The following is a single query string passed within a MATLAB cell array

queries = {"g.V().drop()"};

%  For multiple queries you can pass comma seperated query strings within the cell array.
```
Note: If a script or query is to be executed repeatedly with slightly different arguments, consider concatenating queries rather than dynamically produced strings, see [basic usage](Documentation/BasicUsageGremlin.md).

### Submit a Gremlin query to Azure Cosmos DB Graph
One can submit small queries synchronously using the `submit()` method. Once the client finishes writing all requests, query response is returned within an object `ResultSet`. One can use the method `get()` to return any resultant dataset pertaining to the query.

```
% Submit queries synchronously

resultSet = gClient.submit(queries);

% Get query results

response = resultSet.get;
```

### Creating and submitting multiple GREMLIN queries.
Use a cell array containing the multiple queries to submit requests to the Gremlin Server.
In the below example, multiple queries are submitted to feed data in the Graph database. Multiple graph vertices with properties such as `id`, `firstName`, `lastName`, `age` and `partitionKey` ar being created with the label `person` with the help of the Gremlin step `addV`.

```
queries  = {"g.addV('person').property('id', 'thomas').property('firstName', 'Thomas').property('age', 44).property('pk', 'pk')",...
    "g.addV('person').property('id', 'mary').property('firstName', 'Mary').property('lastName', 'Andersen').property('age', 39).property('pk', 'pk')",...
    "g.addV('person').property('id', 'ben').property('firstName', 'Ben').property('lastName', 'Miller').property('age', 55).property('pk', 'pk')",...
    "g.addV('person').property('id', 'robin').property('firstName', 'Robin').property('lastName', 'Wakefield').property('age', 22).property('pk', 'pk')"};
```

### Submitting Asynchronous requests.
One can submit multiple or large queries asynchronously using the `submitAsync` method, where the query results can be gathered once the client completes writing all queries.

```
% Resultset of type completablefurture is returned
completableFutureResults = gClient.submitAsync(queries);

% Get final Response post asynchronous call completion
response = completableFutureResults.get;
```

### Closing the client connection to the Database
```
gClient.close()

```
## Supported Products

MathWorks Products (http://www.mathworks.com)
1.  MATLAB (R2017b or later)
2.  MATLAB Compiler and Compiler SDK (R2017b or later)
3.  MATLAB Production Server (R2017b or later)
4.  MATLAB Parallel Server (R2017b or later)

This package is primarily tested on Ubuntu™ 20.04 and Windows™ 10.

## License
The license for the MATLAB Interface *for Azure Cosmos DB* is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository. This package uses certain third-party content which is licensed under separate license agreements. See the [SQL/pom.xml](Software/SQL/Java/pom.xml) & [Gremlin/pom.xml](Software/Gremlin/Java/pom.xml) files for third-party software downloaded at build time.    

## Enhancement Request
Provide suggestions for additional features or capabilities using the following link:   
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support
Email: `mwlab@mathworks.com`

[//]: #  (Copyright 2019-2023, The MathWorks, Inc.)
