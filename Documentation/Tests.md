# Test Suite

## Running Supplied Tests
An extensive test suite for the SQL API is included, this can be used to validate the installation but also as a source of basic sample code. Before running the tests is is required to configure a file containing credentials as described in section *Create a Cosmos DB SQL API account* of [SQL Basic Usage](BasicUsageSQL.md).

The tests can be found in */Software/MATLAB/SQL/test/unit/testDocumentDb.m*. To run the tests:
* Run the startup.m command as normal
* Change to the directory containing the tests and run: *runtests(testDocumentDb)*
* To run just a single test of interest: *runtests(testDocumentDb/<test_of_interest_name>)*

Running the tests requires the rights to create and delete Cosmos Databases and their contents. Exercise caution when deleting databases, it is strongly advised to use a testing and development Cosmos DB account.

----------------

[//]: #  (Copyright 2019 The MathWorks, Inc.)
