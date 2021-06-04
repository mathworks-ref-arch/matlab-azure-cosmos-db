#  Use with MATLAB Production Server and MATLAB Compiler

The following applies to the to SQL and Gremlin interfaces only. If using the Table interface please see the corresponding section in the MATLAB® Interface *for Windows® Azure™ Storage Blob (WASB)* documentation.

When using the interface with MATLAB Production Server™ or MATLAB Compiler™ it is normal to use the respective Compiler GUIs. There are three points to note when deploying applications in this way:    
1. Paths are normally configured using the startup.m script in the */Software/MATLAB/<API - SQL or Gremlin>* directory. When deploying an application that calls this package the paths are not configured in that way and the startup script will have no effect. No end user action is required in this regard.    
2. Once compiled, a .jar file can be found in */Software/MATLAB/<API - SQL (and)or Gremlin>/lib/jar/*, this file includes the required functionality from the Microsoft® Java® SDK. The automatic dependency analysis will not pick this up and it must be added manually.
3. For testing purposes adding a credentials .json (and)or .yml file manually, as per the jar file, is a simple way to include credentials in a way that will be easily found by the deployed code. While the credentials file will be encrypted it will be included in the MATLAB Compiler output which may be shared. This may well violate local security polices and best practice. Consider other approaches to providing credentials to deployed applications. Also consider the overall compiling and deployment process and avoid a scenario which involves credentials being included in source code repositories where they may be exposed.

------------

[//]: #  (Copyright 2019-2020, The MathWorks, Inc.)
