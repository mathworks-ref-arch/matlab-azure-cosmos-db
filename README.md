#  MATLAB Interface *for Azure Cosmos DB*

This is a MATLAB® interface that connects to the Microsoft® Azure Cosmos DB™ service.

## Requirements
### MathWorks products
* Requires MATLAB release R2017b or later
* Requires Database Toolbox (for MongoDB API)
* [MATLAB Interface *for Windows Azure Storage Blob*](https://github.com/mathworks-ref-arch/matlab-azure-blob) release 0.7.4 or later

### 3rd party products
To build a required JAR file:
* Maven™
* JDK 8
* Microsoft® Azure Cosmos DB SDK for Java®

## Getting started

Please refer to the documents in the [Documentation](Documentation/README.md) folder to get started. In particular, the Basic Usage guides which provide an overview for using the interface.

Azure Cosmos DB is a globally distributed, multi-model database from Microsoft. Azure Cosmos DB enables you to elastically and independently scale throughput and storage across any number of Azure's geographic regions. It offers throughput, latency, availability, and consistency guarantees with comprehensive service level agreements.

This interface supports three interfaces for Cosmos DB:
  * MongoDB API
  * SQL (DocumentDB) API
  * Table API

The Gremlin API and Cassandra API are not currently supported.

## SQL API
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
The Table API supports the features provided by the Table interface provided by the [MATLAB Interface *for Windows Azure Storage Blob*](https://github.com/mathworks-ref-arch/matlab-azure-blob).

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
MongoDB API support requires the installation of the MathWorks Database Toolbox and the Database Toolbox Interface for MongoDB. This package installation details can be found here: [https://www.mathworks.com/help/database/ug/database-toolbox-interface-for-mongodb-installation.html](https://www.mathworks.com/help/database/ug/database-toolbox-interface-for-mongodb-installation.html).

The following sample code connects to a database and inserts some sample data.
```
%% Create connection to Cosmos DB Mongo API
% Use valid values for myusername, mydatabasename, myusername & password
conn = mongo("myusername.documents.azure.com", 10255, "mydatabasename",...
"UserName", "myusername",...
"Password", "sa<REDACTED>Ewg==",...
"AuthMechanism", "MONGODB_CR", "SSLEnable", true);

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

## Supported Products

MathWorks Products (http://www.mathworks.com)
1.  MATLAB (R2017b or later)
2.  MATLAB Compiler and Compiler SDK (R2017b or later)
3.  MATLAB Production Server (R2017b or later)
4.  MATLAB Parallel Server (R2017b or later)

This package is primarily tested on Ubuntu™ 16.04 and Windows™ 10.

## License
The license for the MATLAB Interface *for Azure Cosmos DB* is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository. This package uses certain third-party content which is licensed under separate license agreements. See the [pom.xml](Software/Java/pom.xml) file for third-party software downloaded at build time.    

## Enhancement Request
Provide suggestions for additional features or capabilities using the following link:   
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support
Email: `mwlab@mathworks.com`

------------
[//]: #  (Copyright 2019-2020, The MathWorks, Inc.)
