# Cosmos DB MongoDB API

## Connecting to Cosmos DB using the MongoDB API

From release 0.2.0 of this package, supplementary support to enable the Cosmos DB MongoDB API is no longer required and has been removed. Database Toolbox R2019b and later along with the Database Toolbox Interface for MongoDB now supports the Cosmos DB MongoDB API directly. For more details see  [Installation](Installation.md).

### Create a Cosmos MongoDB API account
Before using this interface, a Cosmos DB account with the MongoDB API specified as the required interface must exist. This can be created within the Azure web portal. The required steps can be found here:
* [https://docs.microsoft.com/en-us/azure/cosmos-db/create-mongodb-java](https://docs.microsoft.com/en-us/azure/cosmos-db/create-mongodb-java)    
Once both the account and a MongoDB database have been created, connect to the database as follows.

### Connect and insert data
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
It is good practice not to store credentials in source code, the supplied test script in *Software/MATLAB/MongoDB/test/unit/testMongoDB.m* provides an example of reading credentials from a file.

## Other MongoDB documentation
For more detailed MongoDB information see the standard documentation included with both Database Toolbox and the Database Toolbox Interface for MongoDB. This can be accessed as follows:
```
doc mongo
doc mongodb
```

## Frequently asked questions

The following error message when trying to establish a MongoDB connection indicates that the *Database Toolbox Interface for MongoDB* is not installed as described in the [Installation](Installation.md) guide:
```
Error using error
Unable to load a message catalog 'mongodb:mongodb'. Please check the file location and format.
Error in mongo (line 166)
                error(message('mongodb:mongodb:driverNotFound'));
```

[//]: #  (Copyright 2018-2021, The MathWorks, Inc.)
