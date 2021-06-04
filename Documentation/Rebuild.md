# Building the Interface

Before using the SQL interface and(or) the Gremlin interface it is required to build the jar file(s) required by this package using [Maven™](https://maven.apache.org/). The package's *pom.xml* file can be found in */Azure-Cosmos-DB/Software/Java/SQL/* and */Azure-Cosmos-DB/Software/Java/Gremlin/* respectively.
Maven requires that a JDK (Java® 8 or later) is installed and that the *JAVA_HOME* environment variable is set to the location of the JDK. On Windows® the *MAVEN_HOME* environment variable should also be set. Consult the Maven documentation for further details.

Using this file do a maven build for respective packages as follows:
* SQL Interface
```
$ cd Azure-Cosmos-DB/Software/Java/SQL
$ mvn clean verify package
```
* Gremlin Interface
```
$ cd Azure-Cosmos-DB/Software/Java/Gremlin
$ mvn clean verify package
```
Installing Maven will be necessary if it is not already installed.

-------------

[//]: #  (Copyright 2019, The MathWorks, Inc.)
