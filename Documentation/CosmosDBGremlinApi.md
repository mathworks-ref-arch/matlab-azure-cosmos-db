# MATLAB Interface *for CosmosDB - Gremlin API Reference*


## Objects:
* `Software\MATLAB\Gremlin\app\system\+azure\@objectgremlin`
* `Software\MATLAB\Gremlin\app\system\+azure\+gremlin\@CompletableFuture`
* `Software\MATLAB\Gremlin\app\system\+azure\+gremlin\@GremlinClient`
* `Software\MATLAB\Gremlin\app\system\+azure\+gremlin\@ResultSet`



------

## @objectgremlin

### @objectgremlin/objectgremlin.m
```notalanguage
  OBJECTGREMLIN Returns Root object for Azure.GremlinClient
 
  Example:
 
        gremlinclient = azure.gremlinclient('credentials.yml')
 
            gremlinclient =
 
                GremlinClient with properties:
                 Handle: [1×1 org.apache.tinkerpop.gremlin.driver.Client$ClusteredClient]

```

------


## @CompletableFuture

### @CompletableFuture/CompletableFuture.m
```notalanguage
  COMPLETABLEFUTURE A Future that may be explicitly completed (setting its value and status), and may be used as a CompletionStage, supporting dependent functions and actions that trigger upon its completion.
 
  Ref: https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CompletableFuture.html

```
### @CompletableFuture/get.m
```notalanguage
  GET Waits if necessary for this future to complete, and then returns its result.
 
  Example:
 
    % Initialize client
    gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
 
    % Write a cell array containing single or a set of multiple queries seperated by comma
    queries = {"g.V().drop()",
               "g.addV('person').property('id','thomas').property('firstName', 'Thomas').property('age',44).property('pk', 'pk')"};
 
    % Submit queries asynchronously
    completableFuture = gremlinClient.submitAsync(queries)
 
    % Get results once queries are written
    response = completableFuture.get
 
  Reference: https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CompletableFuture.html#get--

```

------


## @GremlinClient

### @GremlinClient/GremlinClient.m
```notalanguage
  GREMLINCLIENT Client used to configure and execute requests
 
  Provides a client-side representation of the Azure Cosmos DB service.
  This client is used to configure and execute requests against the service.
  The service client holds the endpoint and credentials used to access
  the Azure Cosmos DB service.
 
  Example:
 
     1. For specifying a credentials file explicitly with service endpoint, database name, graph name
     and authentication details as an input argument
 
     gremlinclient = azure.gremlinclient('credentials.yml')
 
       gremlinclient =
 
           GremlinClient with properties:
              Handle: [1×1 org.apache.tinkerpop.gremlin.driver.Client$ClusteredClient]
 
     2. For using default credentials file 'gremlindb.yml' containing service endpoint, database name, graph name
     and authentication details, no input argument is needed. The
     default 'gremlindb.yml' file should be on path. e.g. Software/MATLAB/config/gremlindb.yml
 
     gremlinclient = azure.gremlinclient()
 
       gremlinclient =
 
           GremlinClient with properties:
              Handle: [1×1 org.apache.tinkerpop.gremlin.driver.Client$ClusteredClient]

```
### @GremlinClient/close.m
```notalanguage
  CLOSE Closes a GremlinClient instance
 
  Usage
 
    gclient.close()

```
### @GremlinClient/getCluster.m
```notalanguage
  GETCLUSTER Returns string containing details of the Cluster Object for this client
 
  Example:
 
    % Initialize client
    gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
 
    % Find cluster details
    cluster = gremlinClient.getCluster();
 

```
### @GremlinClient/submit.m
```notalanguage
  SUBMIT submits a query to Gremlin DB and returns a Graph Query Response of type ResultSet.
 
  queries is a set of input queries ranging from 1 to any number
 
  Input argument 'queries' is of the type cell array containing comma
  seperated query strings e.g. queries = {"query1", "query2",...,"queryn"};
 
  Example:
 
    % Initialize client
    gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
 
    % Write a cell array containing single or a set of multiple queries seperated by comma
    queries = {"g.V().drop()",
               "g.addV('person').property('id','thomas').property('firstName', 'Thomas').property('age',44).property('pk', 'pk')"};
 
    % Submit queries
    response = gremlinClient.submit(queries)
 

```
### @GremlinClient/submitAsync.m
```notalanguage
  SUBMITASYNC submits a query to Gremlin DB and returns a Graph Query Response of type CompletableFuture.
 
  This is an asynchronous version of gremlinclient.submit("queries"),
  where the returned future will complete when the write of the request completes.
 
  queries is a set of input queries ranging from 1 to any number
 
  Input argument 'queries' is of the type cell array containing comma
  seperated query strings e.g. queries = {"query1", "query2",...,"queryn"};
 
  Example:
 
    % Initialize client
    gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
 
    % Write a cell array containing single or a set of multiple queries seperated by comma
    queries = {"g.V().drop()",
               "g.addV('person').property('id','thomas').property('firstName', 'Thomas').property('age',44).property('pk', 'pk')"};
 
    % Submit queries
    response = gremlinClient.submitAsync(queries)
 

```

------


## @ResultSet

### @ResultSet/ResultSet.m
```notalanguage
  RESULTSET is returned from the submission of a Gremlin script to the server and
  represents the results provided by the server.
 
  The results from the server are streamed into the ResultSet and therefore
  may not be available immediately.
 
  As such, ResultSet provides access to a number of functions that help to work with the asynchronous nature of the data streaming back.
  Data from results is stored in an Result which can be used to retrieve the item once it is on the client side.
 
  Note: A ResultSet is a forward-only stream only so depending on how the methods are called and interacted with, it is possible to return partial bits of the total response (e.g. calling one() followed by all() will make it so that the List of results returned from all() have one Result missing from the total set as it was already retrieved by one().
 
  Ref : https://tinkerpop.apache.org/javadocs/current/full/org/apache/tinkerpop/gremlin/driver/ResultSet.html

```
### @ResultSet/all.m
```notalanguage
  The returned CompletableFuture completes when all reads are complete for this request
  and the entire result has been accounted for on the client.
 
     CompletableFuture<List<Result>>	resultset.all()

```
### @ResultSet/allItemsAvailable.m
```notalanguage
 ALLITEMSAVAILABLE Determines if all items have been returned to the client
 
  Returns true or false depending if the result item has been returned or
  not at the current time
 
  Example:
 
    %Initialize a client
    gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
 
    %Create an "Add people as vetices" query and submit synchronously by using ```submit()```
 
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
 

```
### @ResultSet/get.m
```notalanguage
  GET custom method to obtain query results from ResultSet by using
  iterator
  ResultDet.iterator() Returns a blocking iterator of the items streaming from the server to the client.
 
  Example:
 
    % Initialize client
    gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
 
    % Write a cell array containing single or a set of multiple queries seperated by comma
    queries = {"g.V().drop()",
               "g.addV('person').property('id','thomas').property('firstName', 'Thomas').property('age',44).property('pk', 'pk')"};
 
    % Submit queries synchronously
    resultSet = gremlinClient.submit(queries)
 
    % Get results once queries are written
    response = resultSet.get
 
  Reference: https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CompletableFuture.html#get--

```

------

## Misc. Related Functions
### functions/Logger.m
```notalanguage
  Logger - Object definition for Logger
  ---------------------------------------------------------------------
  Abstract: A logger object to encapsulate logging and debugging
            messages for a MATLAB application.
 
  Syntax:
            logObj = Logger.getLogger();
 
  Logger Properties:
 
      LogFileLevel - The level of log messages that will be saved to the
      log file
 
      DisplayLevel - The level of log messages that will be displayed
      in the command window
 
      LogFile - The file name or path to the log file. If empty,
      nothing will be logged to file.
 
      Messages - Structure array containing log messages
 
  Logger Methods:
 
      clearMessages(obj) - Clears the log messages currently stored in
      the Logger object
 
      clearLogFile(obj) - Clears the log messages currently stored in
      the log file
 
      write(obj,Level,MessageText) - Writes a message to the log
 
  Examples:
      logObj = Logger.getLogger();
      write(logObj,'warning','My warning message')
 



```
### functions/azGremlinCosmosDBRoot.m
```notalanguage
  AZGREMLINCOSMOSDBROOT Helper function to locate the Azure Cosmos DB interface
 
  Locate the installation of the Azure tooling to allow easier construction
  of absolute paths to the required dependencies.



```
### functions/value_unpack.m
```notalanguage
 VALUE_UNPACK Returns unpacked hashmaps and ArrayList of Hasmaps
 
  This function is used in recursion to unpack graph objects with
  properties. The traversal strategy is depth first(instead of breadth
  first)
 
  Package methods consuming this function include @ResultSet.get() and
  @CompletableFuture.get()
 
  Note: This function is not independently avaialbel for use outside the get
  methods mentioned above and is limited to unpacking result types this
  package has been tested for.
 



```



------------    

[//]: # (Copyright 2019 - 2020, The MathWorks, Inc.)
