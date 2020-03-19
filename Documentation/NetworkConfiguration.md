# Network proxy configuration

From an enterprise's network it may be required to use a http(s) proxy to get access to the Internet and thus Azure's™ Blob servers (Table API) or the Cosmos DB servers.

## Using the Table API

To use a proxy server create an OperationContext object as follows:
```
% if using the Table API
az = azure.storage.CloudStorageAccount;
az.loadConfigurationSettings();
az.connect();
oc = azure.storage.OperationContext();
```

Typically create the OperationContext object when configuring the account (as shown) and prior to creating a client. This context will set the default proxy values based on the MATLAB® preferences where set and on Windows® the system preferences. To override this behavior call setDefaultProxy() subsequently with the desired arguments.

![PreferencesPanel](Images/prefspanel.png)

To set the default proxy to a value other than that set in the MATLAB preferences call setDefaultProxy as follows:
```
oc.setDefaultProxy('myproxy.example.com', 8080);
```
To set the default to a direct connection i.e. no proxy or the default behavior without a OperationContext:
```
oc.setDefaultProxy('NO_PROXY');
```
Once set these settings will be used for subsequent data transfers with Azure Blob/Table storage.

## Using the SQL API

If using the SQL API proxy support is configured using a ConnectionPolicy object.
```
database = azure.documentdb.Database('mydbname');

% create a ConnectionPolicy object and set the proxy as shown
myConnectionPolicy = azure.documentdb.ConnectionPolicy();
myConnectionPolicy.setProxy('http://proxy.example.com:3128');

% pass the ConnectionPolicy to the client constructor
docClient = azure.documentdb.DocumentClient('connectionPolicy', myConnectionPolicy);

% proceed as normal, the proxy will now be used for subsequent Cosmos DB SQL calls.
docClient.createDatabase(database);

```

To use the values specified in the MATLAB preferences pane, as shown above, or on Windows the system defaults do not specify any arguments in the ```setProxy()``` call.

```
myConnectionPolicy = azure.documentdb.ConnectionPolicy();
myConnectionPolicy.setProxy();

% pass the ConnectionPolicy to the client constructor
docClient = azure.documentdb.DocumentClient('connectionPolicy', myConnectionPolicy);
```
The proxy settings take effect at the underlying Java layer they will apply to all clients thus one cannot have different clients with different proxies in the same session.

----------------

[//]: #  (Copyright 2017, The MathWorks, Inc.)
