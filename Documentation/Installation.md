# Installation

## Installing on Windows®, macOS® and Linux

If installing based on a source code only, e.g. from GitHub, first build any required jar files. Instructions to do can be found here: [Build](Rebuild.md). Once built the package is installed as follows.

### SQL Interface
1. Copy the contents of the package to the desired location.
2. From within MATLAB® change directory to that location and then to the Software/SQL/MATLAB subdirectory and run the *startup.m* file. This updates the relevant paths. Output similar to the following should be shown:
![Running startup](Images/SQL/installstartup.png)
The package is now ready for use.


### MongoDB Interface
The interface's Cosmos DB MongoDB API support requires the following installation steps:
1. Ensure the MathWorks Database Toolbox is installed, it should be visible in the list returned by the *ver* command if installed.
2. Install the Database Toolbox Interface for MongoDB. This package installation details can be found here: [https://www.mathworks.com/help/database/ug/database-toolbox-interface-for-mongodb-installation.html](https://www.mathworks.com/help/database/ug/database-toolbox-interface-for-mongodb-installation.html). Select the latest release. Once installed it will appear in add-on manager as shown:
![Add-on manager](Images/MongoDB/mongo_interface.png)
3. Add the path to the *Software/MATLAB/MongoDB* directory to the MATLAB path:
```
addpath(mongoRoot,'-begin');
```
Note this must be added to the beginning of the path so that the included *mongo.m* overrides the corresponding file that supports conventional MongoDB access.

### Table Interface
1. The Cosmos DB Table interface uses the [MATLAB Interface *for Windows Azure Storage Blob*](https://github.com/mathworks-ref-arch/matlab-azure-blob) package to provide underlying support for the Azure WASB Table API. This Interface should be first downloaded and installed.
2. Using the Cosmos DB interface Table API is then a question of using Cosmos DB specific connection process.

MATLAB can be configured to call startup.m on startup if preferred so that the package is always available automatically. For further details see: [https://www.mathworks.com/help/matlab/ref/startup.html](https://www.mathworks.com/help/matlab/ref/startup.html). Path updates can also be invoked at startup in this way.

----------------

[//]: #  (Copyright 2017 The MathWorks, Inc.)
