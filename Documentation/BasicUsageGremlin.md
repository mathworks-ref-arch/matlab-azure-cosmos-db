# MATLAB Interface *for Azure Cosmos DB* - Gremlin API

## Getting Started
The Cosmos DB Gremlin API supported by this package builds upon the Apache TinkerPop™ for the Cosmos DB Gremlin API. Azure Cosmos DB's Gremlin API is based on the Apache TinkerPop graph database standard, and uses the Gremlin query language. Further details can be found here: [https://docs.microsoft.com/en-us/azure/cosmos-db/graph-introduction](https://docs.microsoft.com/en-us/azure/cosmos-db/graph-introduction)

This document is a basic guide to using the Interface and does not describe Cosmos DB itself or all of the supported operations.

## Create a Cosmos DB Gremlin API account
Before using Gremlin API, create a Cosmos DB account with Gremlin API specified as the interface. The necessary steps can be found here: [https://docs.microsoft.com/en-us/azure/cosmos-db/create-graph-dotnet#create-a-database-account](https://docs.microsoft.com/en-us/azure/cosmos-db/create-graph-dotnet#create-a-database-account)

Note the account name and key as they will be required to authenticate the client to Cosmos DB. By default the interface searches the path for a file containing these values called: *gremlindb.yml*. It should have the following structure:
```
hosts: [$REDACTED$.gremlin.cosmosdb.azure.com]
port: 443
username: /dbs/$sample-database$/colls/$sample-graph$
password: l8HmREDACTEDTHmg==
connectionPool: {
  enableSsl: true}
serializer: { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV2d0, config: { serializeResultToString: true }}

```
An alternative file name or specific values can be provided when creating a *GremlinClient()*, if preferred. These values should be should be kept securely.

## Connect to Cosmos DB with Gremlin API
A *GremlinClient()* object is primarily used to connect to Cosmos DB, this is created as follows:
```
gClient = azure.gremlin.GremlinClient('mygremlindb.yml')
```
This assumes that credentials are read in the default manner, as previously described. When no longer needed it is good practice to close the client.
```
gClient.close;
```

## Creating a Cosmos DB Gremlin client, Submitting Queries and Reading Reponses

```
% create a gremlin client
gClient = azure.gremlin.GremlinClient('mygremlindb.yml')
```

## Gremlin API

The Gremlin API allows you to create and manage an Azure Cosmos DB Gremlin (graph) API account.
Features include:
* add data to graph database
* query data from graph database

1. Connecting to graph database, writing queries for data insertion and exploration.
```
%% Create connection to Cosmos DB Gremlin API

gClient = azure.gremlin.GremlinClient('gremlindb.yml')

gClient = 

  GremlinClient with properties:

    Handle: [1x1 org.apache.tinkerpop.gremlin.driver.Client$ClusteredClient]

%% Create a graph query and submit synchronously

% Dropping current grpah if any
queries = {"g.V().drop()"};

% Get resultset
resultset = gClient.submit(queries)

[2020-03-30 11:13:16,772] INFO Created new connection for wss://cosmos-REDACTED-gremlin.gremlin.cosmosdb.azure.com:443/gremlin (org.apache.tinkerpop.gremlin.driver.Connection)

[2020-03-30 11:13:16,942] INFO Created new connection for wss://cosmos-REDACTED-gremlin.gremlin.cosmosdb.azure.com:443/gremlin (org.apache.tinkerpop.gremlin.driver.Connection)

[2020-03-30 11:13:16,942] INFO Opening connection pool on Host{address=cosmos-REDACTED-gremlin.gremlin.cosmosdb.azure.com/123.45.678.90:443, hostUri=wss://cosmos-REDACTED-gremlin.gremlin.cosmosdb.azure.com:443/gremlin} with core size of 2 (org.apache.tinkerpop.gremlin.driver.ConnectionPool)


resultset = 

  ResultSet with properties:

    Handle: {[1x1 org.apache.tinkerpop.gremlin.driver.ResultSet]}

% Check if results for all queried objects are available
  
tf = resultset.allItemsAvailable

tf =

  1x1 cell array

    {[1]}

Note: if there are multiple queries the cell array size will be greater than 1 containing boolean values indicating status of completion of the query

% Read results
response = resultset.get

  1x1 cell array

    {1x1 struct}

Note: If the queries are not expected to return any dataset from the graph database, the resultant struct will be empty with no fields

% Create an "Add people as vetices" query and submit synchronously by using ```submit()```

queries  = {"g.addV('person').property('id', 'thomas').property('firstName', 'Thomas').property('age', 44).property('pk', 'pk')",...
    "g.addV('person').property('id', 'mary').property('firstName', 'Mary').property('lastName', 'Andersen').property('age', 39).property('pk', 'pk')",...
    "g.addV('person').property('id', 'ben').property('firstName', 'Ben').property('lastName', 'Miller').property('age', 55).property('pk', 'pk')",...
    "g.addV('person').property('id', 'robin').property('firstName', 'Robin').property('lastName', 'Wakefield').property('age', 22).property('pk', 'pk')"};

% Get resultset

resultset = gClient.submit(queries)

resultset = 

  ResultSet with properties:

    Handle: {4x1 cell}

% Check if results are ready to be read
tf = resultset.allItemsAvailable

tf =

  1x4 cell array

    {[1]}    {[1]}    {[1]}    {[1]}

% Read results
response = resultset.get

response =

  4x1 cell array

    {1x1 cell}
    {1x1 cell}
    {1x1 cell}
    {1x1 cell}

% Reading results from response object

response{1}{1}

ans = 

  struct with fields:

            id: 'thomas'
         label: 'person'
          type: 'vertex'
    properties: [1x1 struct]

% Accessing properties of the graph vertex

ans.properties

ans = 

  struct with fields:

    firstName: [1x1 struct]
          age: [1x1 struct]
           pk: [1x1 struct]


% Create an "Add relation between people vertices" query and submit to get results

queries = {"g.V('thomas').addE('knows').to(g.V('mary'))",...
    "g.V('thomas').addE('knows').to(g.V('ben'))",...
    "g.V('ben').addE('knows').to(g.V('robin'))"};

% Get resultset
resultset = gClient.submit(queries)

resultset = 

  ResultSet with properties:

    Handle: {3x1 cell}

% Read and traverse results

response =

  3x1 cell array

    {1x1 cell}
    {1x1 cell}
    {1x1 cell}

response{1}{1}

ans = 

  struct with fields:

           id: 'f5f7c0a9-6238-4f5b-96bf-125042b12f94'
        label: 'knows'
         type: 'edge'
     inVLabel: 'person'
    outVLabel: 'person'
          inV: 'mary'
         outV: 'thomas'

response{2}{1}

ans = 

  struct with fields:

           id: 'f6d54ed7-07f8-4f00-aa13-1662e3868ad7'
        label: 'knows'
         type: 'edge'
     inVLabel: 'person'
    outVLabel: 'person'
          inV: 'ben'
         outV: 'thomas'

% Count number of people(vertices) in a graph
queries = {"g.V().count()"};

% Get resultset
resultset = gClient.submit(queries)

resultset = 

  ResultSet with properties:

    Handle: {[1x1 org.apache.tinkerpop.gremlin.driver.ResultSet]}

% Read Results
response = resultset.get

response =

  1x1 cell array

    {1x1 cell}

response{1}{1}

ans =

     4
```

### Create and submit queries asynchronously

```
% Example: listing all people with names in alphabetically descending in order

% query for listing people from graph verices with names in descending order
queries = { "g.V().hasLabel('person').order().by('firstName', decr)"};

% Get ResultSet in asynchronously by using submitAsync()

completableFutureResults = gClient.submitAsync(queries)

completableFutureResults = 

  CompletableFuture with properties:

    Handle: {[1x1 java.util.concurrent.CompletableFuture]}

% Get final Response

response = completableFutureResults.get

response =

  1x1 cell array

    {1x4 struct}

% response is a cell array with 4 structs containing information about 4 vertices with property name/id in descending order

response{1}

ans = 

  1x4 struct array with fields:

    id
    label
    type
    properties

% Check first person in list - [Thomas , Robin, Mary, Ben]

response{1}(1)

ans = 

  struct with fields:

            id: 'thomas'
         label: 'person'
          type: 'vertex'
    properties: [1x1 struct]

% Check last person in list - [Thomas , Robin, Mary, Ben]

 response{1}(4)

ans = 

  struct with fields:

            id: 'ben'
         label: 'person'
          type: 'vertex'
    properties: [1x1 struct]

% close the client when finished, note the database remains in existence
% and will result in charges to the Azure account in question unless deleted

gClient.close;

```

2. Creating dynamic and parameterized queries for Graph Database.
```
% Create Client
gClient = azure.gremlin.GremlinClient();

% Create airport graph with parameterized queries

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

% Create edges/routes between 5 airport 

for i = 1: numel(from)
    edgequerystr{i} = strcat("g.V('", upper(from{i}), "').addE('" ,edgetype, "').to(g.V('", upper(to{i}), "'))");
end

% Submit and get results post execution

resultset = gClient.submit( edgequerystr);
response = resultset.get;

% Query routes from lax

strcat("g.V('",upper(origin),"').")

% Close client connection

gClient.close

```
For guidance there is also an end to end example avaialble within ```MATLAB/Gremlin/script```

## References:
* [Azure Cosmos DB Introduction](https://docs.microsoft.com/en-us/azure/cosmos-db/)
* [Apache TinkerPop™ Javadoc](https://tinkerpop.apache.org/javadocs/current/full/)
* [Quickstart for Java SDK and the Azure Cosmos DB Gremlin API](https://docs.microsoft.com/en-us/azure/cosmos-db/create-graph-java)

------------

## Notes:
[Microsoft® Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/) is a free, standalone application from Microsoft that provides a GUI for Azure Storage data on Windows®, macOS®, and Linux.
When installed, it is possible to bring this up from MATLAB using the *AzureStorageExplorer* command. For more information, please see: https://docs.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer

----------------

[//]: #  (Copyright 2020, The MathWorks, Inc.)
