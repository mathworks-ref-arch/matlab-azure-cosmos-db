# Cosmos DB Table API

## Getting Started
Cosmos DB™ Table API requires the [MATLAB® Interface *for Windows Azure Storage Blob*](https://github.com/mathworks-ref-arch/matlab-azure-blob) release 0.7.4 or later. This document describes the initial steps to connect to Cosmos DB using the Table API. Note, the MATLAB WASB and Cosmos DB Table API interfaces are identical with the exception of the configuration of the CloudStorageAccount object, thus code is easy to move from one to the other. In terms of the underlying Azure differences the primary difference lies in the terms of service. Cosmos DB Table offers higher performance and quality of service guarantees than WASB Table, though at considerably higher cost. There are some technical differences and these are discussed in the following document: [https://docs.microsoft.com/en-us/azure/cosmos-db/faq#where-is-table-api-not-identical-with-azure-table-storage-behavior](https://docs.microsoft.com/en-us/azure/cosmos-db/faq#where-is-table-api-not-identical-with-azure-table-storage-behavior).

 The choice of interfaces from within MATLAB allows one to choose the best compromise of performance and cost. Both interfaces can operate simultaneously, for example, if certain queries are more performance critical than others. This is done by creating a CloudStorageAccount object and corresponding Client for each interface.

## Connecting to Cosmos DB using Table API Client
### Create a Cosmos DB Table API account
Before using the Table API client, a Cosmos DB account with Table API specified as the interface must be created. The steps are described in the following page: [https://docs.microsoft.com/en-us/azure/cosmos-db/create-table-java](https://docs.microsoft.com/en-us/azure/cosmos-db/create-table-java)
Once created, the account can be connected to.

### Create and configure a storage account
The [MATLAB® Interface *for Windows Azure Storage Blob*](https://github.com/mathworks-ref-arch/matlab-azure-blob) must be installed and and started to added the required Table interface to the path. To connect to the Cosmos DB Table API, first configure a CloudStorageAccount object. In addition to credentials this requires the following steps:
1. Specify if the WASB Interface target is Cosmos DB, by default the *CosmosDB* property is set to false, this should be set to true.
2. Set ServiceName to *'table'*, since we are going to use the Table API interface
3. Set the DefaultEndpointsProtocol to *'https'* as normal when using Cosmos DB.

Sample code to do so is as follows:
```
% Create a handle to the storage account
az = azure.storage.CloudStorageAccount;

% Use Azure based storage
az.UseDevelopmentStorage = false;

% Account name and key as shown in the Azure portal Cosmos DB interface
az.AccountName = 'myaccountname'
az.AccountKey  = 'SVn<MYACCOUNTKEY>0GGw=='

% Configure connection properties
az.DefaultEndpointsProtocol='https'
az.ServiceName = 'table'
az.CosmosDB = true;
% CloudStorageAccount configuration is complete

```
Rather than configuring the storage account credentials in code which requires the sensitive account key to be embedded in code we can load it and other related settings from a file which is more readily protected.
```
az.loadConfigurationSettings();
```
Storing the settings in a file also allows for more simple management of multiple storage accounts. The file is a short json file stored in the WASB Interface *Software/MATLAB/SQL/config* directory by default, the template for which is as follows:
```
{
    "DefaultEndpointsProtocol" : "https",
    "AccountKey" : "SVn<MYACCOUNTKEY>0GGw==",
    "UseDevelopmentStorage" : "false",
    "AccountName" : "mycosmosdbaccountname",
    "ServiceName" : "table",
    "CosmosDB" : "true"
}
```
By default a configuration file named *cloudstorageaccount.json* on the MATLAB path is searched for. To use an alternate filename pass it as an argument to *loadConfigurationSettings()*. This can be useful if more than one account is needed at the same time for example if one file corresponds to a Cosmos DB account and another for blob account.
```
>> az.loadConfigurationSettings('myCosmosDBStorageAccount.json');
```

The account is now ready to connect. When fully configured this looks like:
```
az.connect()
az

az =

  CloudStorageAccount with properties:

                   AccountName: 'myaccountname'
                    AccountKey: 'SVn<MYACCOUNTKEY>=='
                   ServiceName: 'table'
      DefaultEndpointsProtocol: 'https'
         UseDevelopmentStorage: 0
                      CosmosDB: 'true'
    DevelopmentStorageProxyUri: []
                     Secondary: 0
                           URI: 'http://myaccountname.table.cosmosdb.azure.com:443/'
                  BlobEndpoint: 'http://myaccountname.blob.core.windows.net'
```

### Create a Client
With a fully configured connection get a handle to a client that is required to perform CRUD (Create, Retrieve, Update, Delete) operations on Table storage.
```
azClient = azure.storage.table.CloudTableClient(az)

azClient =

  CloudTableClient with properties:

    Parent: [1x1 azure.storage.CloudStorageAccount]
```
Alternatively, it is possible to create a client using:
```
azClient = az.getCloudTableClient();
```
Now Windows Azure Table storage can be accessed from MATLAB.

See [Logging](Logging.md) for details of enabling verbose output during development and testing.

### Create a table
A *CloudTableClient* object gets reference objects for tables and entities. The following code creates a *CloudTableClient* object and uses it to create a new *CloudTable* object which represents a table called *sampletable*. A *CloudTable* object is required for most Table operations.

```
tableHandle = azure.storage.table.CloudTable(azClient,'sampletable');
tableHandle.createIfNotExists();
```

### List existing tables
To get a list of tables, call the *CloudTableClient.listTables()* method to retrieve an list of table names.
```
tableList = azClient.listTables

tableList =

  1x14 CloudTable array with properties:

    Parent
    Name
```
The output of this method is an array of Table handles for accessing the tables on Azure. This list can be easily converted into a MATLAB table using:

```
table({tableList.Name}','VariableNames',{'Name'})

ans =

  14x1 table

                        Name                     
    _____________________________________________

    ["CAPStablec07e753632434708bbe06ec87401e59d"]
    ["myaccttable"                              ]
    ["insertdeletetable"                        ]
    ["inserttestechotable"                      ]
    ["inserttestnoechotable"                    ]
    ["MasterController"                         ]
    ["mpsInstances"                             ]
    ["sampletable"                              ]
    ["slaves"                                   ]
    ["testbasicretrieve"                        ]
    ["testdelete"                               ]
    ["testreplace"                              ]
    ["testretrieve"                             ]
    ["testtable"                                ]

```

### Add an entity to a table
Entities map to objects. This can be achieved either by using the *DynamicTableEntity* or using a custom class deriving from it. To add an entity to a table, either first create a class that defines the properties of your entity or create the properties dynamically. The following code defines the *DynamicTableEntity*. As an example, the entity contains a customer's first name as the row key, and last name as the partition key. Together, an entity's partition and row key uniquely identify the entity in the table. Entities with the same partition key can be queried faster than those with different partition keys.

```
% Add the first and last name
dynamicEntity = azure.storage.table.DynamicTableEntity;
dynamicEntity.rowKey = 'John';
dynamicEntity.partitionKey = 'Smith';

% Dynamically define a property to store a value and assign a random number to it.
dynamicEntity.addprop('Value');
dynamicEntity.Value = rand(1,1);
dynamicEntity.initialize();

```

Table operations involving entities require a *TableOperation* object. This object defines the operation to be performed on an entity, which can be executed with a *CloudTable* object. The *TableOperation.insertOrReplace()* can be used to create a TableOperation object to insert an entity into a table. Finally, the code calls the execute method on the *CloudTable* object, specifying the "sampletable" table and the new *TableOperation*, which then sends a request to the storage service to insert the new customer entity into the "sampletable" table, or replace the entity if it already exists.

```
tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity, true);
tableHandle.execute(tableOperation);
```

Methods to merely insert, replace/update or merge entities operate in the same manner.
To update all of an entity's property values, call the update method. If the entity that is being updated does not already exist, then the update operation will fail. To store an entity whether it exists or not, use *insertOrReplace()* to perform an upsert.

The *update()* method replaces all properties and values of an existing entity, which can also be used to remove properties from an existing entity. The *merge()* method can be used to update an existing entity with new or modified property values without completely replacing the entity.

### Insert a batch of entities to a table
Inserting a batch of entities to the table service in one write operation is handled automatically via vectorization under the API on TableOperation object. The implementation uses a *TableBatchOperation* object internally, which sends the batch of table operations to the storage service in a single request. For example, to create a 100 entities as a batch operation:

```
% Create a number of sample entities and insert into the database
% Partition them appropriately modulo 20
batchSize = 100;
partitionSize = 20;
for bCount = 1:batchSize
    dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
    dynamicEntity(bCount).addprop('Name');
    dynamicEntity(bCount).Name = ['john',num2str(bCount)];
    dynamicEntity(bCount).partitionKey = ['pk', num2str(ceil(bCount/partitionSize))];
    dynamicEntity(bCount).rowKey = ['rk', char(java.util.UUID.randomUUID())];
    dynamicEntity(bCount).addprop('Value');
    dynamicEntity(bCount).Value = rand(1,1);
    dynamicEntity(bCount).initialize();
end
```

The batch operations performed as a single atomic operation on the Azure Table API service are constrained by a few noteworthy restrictions:
* A single batch size cannot exceed 100 entities
* All entities in a single batch need to have the same partition key
* The total payload of a batch operation is limited to 4MB

Since the example above uses multiple partitionKeys to partition the data, the insertion will need to adhere to batches of 20 entities with the same key.

```
tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(1:20), true); % vectorized
tableHandle.execute(tableOperation);
```

### Retrieve a single entity
To query a table for entities in a partition, use a *TableQuery*. Call *TableQuery.where* to create a query on a particular table that returns a specified result. For example, a filter for entities where 'Smith' is the partition key. *TableQuery.generateFilterCondition* is a helper method to create filters for queries. When the query is executed with a call to execute on the *CloudTable* object, it returns an array of *TableResult* objects. For example to retrieve the entity that was inserted earlier.

```
% Create a dynamic resolver (return as Java HashMap)
dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();

% Specify the partition key and row key, pk & rk.
pk = 'Smith';
rk = 'John';
tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
results = tableHandle.execute(tableOperation)

results =

  TableResult with properties:

    Value: 0.17
```

Note that in this case, the returned TableResults omit the partition and row keys since they were a part of the input.

### Retrieve all entities in a partition
This is similar to retrieving a single entity but is much simpler since the return is a *DynamicTableEntity*. For example, to return all entities from the first partition in the example above.
```
% Fetch the elements from the first partition
pk = 'pk1';

% Setup the query
queryComp = azure.storage.table.QueryComparisons.EQUAL;
filterCondition = azure.storage.table.TableQuery.generateFilterCondition('PartitionKey', queryComp, pk);

% Create a new table query;
tableQuery = azure.storage.table.TableQuery;
finalQuery = tableQuery.where(filterCondition);

% Query the database
queryResults = tableHandle.execute(finalQuery);

queryResults =

  1x20 DynamicTableEntity array with properties:

    partitionKey
    rowKey
```

Inspecting a single result:
```
queryResults(1)

ans =

  DynamicTableEntity with properties:

    partitionKey: 'pk1'
          rowKey: 'rk033849c9-6cc2-47d0-9857-d078cd5613d3'
            Name: 'john6'
           Value: 0.40
       timestamp: 'Fri Feb 09 17:42:36 PST 2018
```

This array can be easily converted to a MATLAB table using:
```
tbl = table(queryResults)

tbl =

  20x5 table

    partitionKey                     rowKey                      Name       Value              timestamp           
    ____________    ________________________________________    ________    _____    ______________________________

    'pk1'           'rk033849c9-6cc2-47d0-9857-d078cd5613d3'    'john6'     0.40     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk04020a9f-240f-41ab-9f63-2750442b4729'    'john1'     0.17     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk15976700-481e-48c6-8c22-6c63db1c4797'    'john8'     0.40     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk163e31eb-1eea-4fd7-9892-bfb3b3958b51'    'john19'    0.83     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk2ece857d-0c91-40f8-8295-646bc81a6702'    'john12'    0.16     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk32736e0a-d10b-4a61-8c41-b58a8cfb2246'    'john4'     0.07     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk3e569f21-fe86-4d8d-a06d-8e4997951f05'    'john13'    0.76     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk49f1f620-ec4b-4f78-b920-55b75ca5c479'    'john5'     0.68     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk4ee2977f-c529-46bb-b0f1-dc0c5afb0f21'    'john18'    0.53     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk5ad7fb4d-726a-47cb-9376-50e1fd0836a9'    'john14'    0.87     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk6ef63b8e-c15d-4cd6-9f09-3f6f77454c1d'    'john16'    0.69     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk7514bf6a-bf4a-44ce-9e99-7d6877022ff0'    'john17'    0.29     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk7dcc0a1a-d345-457f-b167-c31bf4684af7'    'john9'     0.62     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk8b4303a3-013c-4398-afb5-bc8894946056'    'john7'     0.98     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rk9df6f8d7-8287-47c3-aeb7-7918095ac435'    'john3'     0.40     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rkb7a94d48-711b-463e-87c9-550802436f9e'    'john10'    0.15     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rkda68dd04-fccc-4d1a-9021-d2c485ed8d15'    'john20'    0.60     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rkde211dc7-af3f-4d99-82de-edf9ed8ec519'    'john11'    0.38     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rkef54952e-4d33-41d9-9a52-bea0499bcc67'    'john15'    0.35     'Fri Feb 09 17:42:36 PST 2018'
    'pk1'           'rkfd168333-ffb0-467b-950b-fa6239bb6c36'    'john2'     0.26     'Fri Feb 09 17:42:36 PST 2018'
```

The query comparisons can be used to create more complex filter conditions to fetch ranges of entities from the Table Service.

### Delete an entity
Entities can be easily deleted after being retrieved. Once the entity is retrieved, call *TableOperation.delete* with the entity to delete. Then call *execute* on the *CloudTable* object. The following code deletes the first entity in the partition above.

```
tableDeleteOperation = azure.storage.table.TableOperation.delete(queryResults(1));
tableHandle.execute(tableDeleteOperation);
```

When querying partition with key "pk1" like in the code above, the table will only return 19 elements since the first element has been deleted.

### Delete a table
It is possible to *delete* a table from a storage account or attempt to delete if a table exists using the *deleteIfExists*.

```
tableHandle.deleteIfExists();
```

A table which has been deleted will be unavailable to be recreated for a period of time following the deletion, usually less than forty seconds. If creation is attempted, the Azure table service will error out with a "Conflict" error. This is pertinent when running the unit tests in an automated fashion.


### Accessing a table via a Shared Access Signature (SAS)

Shared Access Signatures allow granular access to tables, queues, blob containers, and blobs. A SAS token can be configured to provide specific access rights, i.e. add, query, update, & delete. to a specific table, key range within a table; for a specified time period or without any limit. The SAS token appears as part of the resource’s URI as a series of query parameters, e.g. <https://myaccountname.table.core.windows.net/mbsampletable?sv=2017-04-17&si=myidentifer&tn=mbsampletable&sig=eaGeUXr4yMvww%2BVTL5zIAmhkdjYwhzBVSM7y%2FPX8bdI%3D>   

Note, because the URL provides access to the table an authenticated client is not needed in this case. Currently Service SASs are supported, as described, however Account SASs are not supported.

```
% A SAS URL which has been provided for an existing table, it is first converted to a MATLAB URI object
SASMatlabURI = matlab.net.URI('https://myaccountname.table.core.windows.net/mbsampletable?sv=2017-04-17&si=myidentifer&tn=mbsampletable&sig=eaGeUXr4yMvww%2BVTL5zIAmhkdjYwhzBVSM7y%2FPX8bdI%3D');

% Create a StorageURI object based on this
SASStorageURI = azure.storage.StorageUri(SASMatlabURI);

% Create a CloudTable object via the StorageURI object
tableHandle = azure.storage.table.CloudTable(SASStorageURI);

% Return the name of the table
tableHandle.Name

% As before build a Table Operation
pk = 'Smith';
rk = 'John';
dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver)

% Query the table using the handle and operation
results = tableHandle.execute(tableOperation)
results =

  TableResult with properties:

    Value: 0.8147
```

### Generating a Shared Access Signature

A SAS may often be provided from a third party source e.g. the Azure Storage Explorer, however it can also be useful to generate a SAS within MATLAB for example if building a system where a web backend passes SAS's to third party clients. The following example uses a previously created table to build a basic SAS. Note not all SAS criteria a re currently supported e.g. IP based restrictions, if additional criteria are required contact MathWorks.

```
% First create a shared access policy, setting permissions and times
myPolicy = azure.storage.table.SharedAccessTablePolicy();
permSet(1) = azure.storage.table.SharedAccessTablePermissions.QUERY;
myPolicy.setPermissions(permSet);

% Allow access for the next 24 hours
t1 = datetime('now');
t2 = t1 + hours(24);
myPolicy.setSharedAccessExpiryTime(t2);

% Allow a margin of 15 minutes for clock variances
t3 = t1 - minutes(15);
myPolicy.setSharedAccessStartTime(t3);


% Set row and partition restrictions
accessPolicyIdentifier = 'myAccessPolicyIdentifier';
startPartitionKey = 'Smith';
startRowKey = 'John';
endPartitionKey = 'Smith';
endRowKey = 'John';

% Generate the SAS, note the leading ? and URI are not included
sas = tableHandle.generateSharedAccessSignature(myPolicy,accessPolicyIdentifier,startPartitionKey,startRowKey,endPartitionKey,endRowKey)

sas =

    'sig=2wOZrXmqMQgJ6KPJXwCVK3D9hxpcY166eMJ8mxDBZdc%3D&st=2018-05-10T08%3A38%3A43Z&epk=Smith&se=2018-05-11T08%3A53%3A43Z&sv=2017-04-17&si=myAccessPolicyIdentifier&tn=sampletable&sp=r&srk=John&spk=Smith&erk=John'

% build the full SAS
myUri = tableHandle.getUri;

fullSas = [char(myUri.EncodedURI),'?',sas]

fullSas =

    'https://myaccountname.table.core.windows.net/sampletable?sig=2wOZrXmqMQgJ6KPJXwCVK3D9hxpcY166eMJ8mxDBZdc%3D&st=2018-05-10T08%3A38%3A43Z&epk=Smith&se=2018-05-11T08%3A53%3A43Z&sv=2017-04-17&si=accessPolicyIdentifier&tn=sampletable&sp=r&srk=John&spk=Smith&erk=John'

```

## Notes:
[Microsoft® Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/) is a free, standalone application from Microsoft that provides a GUI for Azure Storage data on Windows®, macOS®, and Linux.
When installed, it is possible to bring this up from MATLAB using the *AzureStorageExplorer* command. For more information, please see: https://docs.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer


----------------

[//]: #  (Copyright 2019, The MathWorks, Inc.)
