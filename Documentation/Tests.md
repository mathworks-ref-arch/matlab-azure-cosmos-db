# Test Suite

## Running Supplied Tests
An extensive test suite for the SQL & Gremlin API is included.
These can be used to validate the installation but also as a source of basic sample code.
Before running the tests it is required to configure credentials for the API in use as described in sections *Create a Cosmos DB SQL API account* of [SQL Basic Usage](BasicUsageSQL.md) and *Create a Cosmos DB Gremlin API account* of [Gremlin Basic Usage](BasicUsageGremlin.md).

The tests can be found in */Software/MATLAB/SQL or Gremlin/test/unit/. To run the tests:
* Run the startup.m command as normal
* Change to the directory containing the tests and run: *runtests(testApiFilename)*
* To run just a single test of interest: *runtests(<testapifilename/test_of_interest_name>)*

Running the tests requires the rights to create and delete Cosmos Databases and their contents. Exercise caution when deleting databases, it is strongly advised to use a testing and development Cosmos DB account.


[//]: #  (Copyright 2019-2021 The MathWorks, Inc.)
