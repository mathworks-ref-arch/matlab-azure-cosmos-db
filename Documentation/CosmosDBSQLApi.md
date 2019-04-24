# MATLAB Interface *for CosmosDB - SQL API Reference*


## Objects:
* `Software\MATLAB\SQL\app\system\+azure\@object`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@Attachment`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@DataType`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@Database`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@Document`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@DocumentClient`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@DocumentCollection`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@FeedOptions`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@FeedResponse`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@IncludedPath`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@IndexKind`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@IndexingPolicy`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@MediaOptions`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@MediaResponse`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@Offer`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@PartitionKey`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@PartitionKeyDefinition`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@RangeIndex`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@RequestOptions`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@ResourceResponse`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@SqlQuerySpec`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@StoredProcedure`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@StoredProcedureResponse`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@Trigger`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@TriggerOperation`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@TriggerType`
* `Software\MATLAB\SQL\app\system\+azure\+documentdb\@UserDefinedFunction`



------

## @object

### @object/object.m
```notalanguage
  OBJECT Root Class for all Azure wrapper objects

```

------


## @Attachment

### @Attachment/Attachment.m
```notalanguage
  ATTACHMENT Represents a document attachment in Cosmos DB
  A document can contain zero or more attachments. Attachments can be of any
  MIME type and are stored externally in Azure Blob storage.
  Attachments are automatically deleted when the parent document is deleted.
  Attachments can be managed or unmanaged. An unmanaged attachments is not
  attached rather a link to external storage is provided. With managed
  attachments storage is 'managed' by Cosmos DB.
 
  Examples:
     % The attachment constructor is called as follows:
     % Passing the attachment as a JSON encoded character vector
     azure.documentdb.Attachment(my_JSON_attachment_character_vector);
     % with no arguments, id, contentType and media values to be set later
     azure.documentdb.Attachment();
     % using an existing Java attachment object of type com.microsoft.azure.documentdb.Attachment
     azure.documentdb.Attachment(myAttachmentObject)
 
     % create an attachment using a JSON character vector
     % create the required documentLink and options arguments
     options = azure.documentdb.RequestOptions();
     documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
     % create a body struct and populate the id, contentType and media fields
     body.id = 'image_id';
     body.contentType = 'image/jpg';
     body.media = 'www.mathworks.com';
     % JSON encode the struct an create the local attachment object using it
     attachment = azure.documentdb.Attachment(jsonencode(body));
     % call the DocumentClient createAttachment method to create the attachment
     % in Cosmos DB
     attachmentResponse = docClient.createAttachment(documentLink, attachment, options);
     % get the resource from the response representing the created object, if required
     attachmentResource = attachmentResponse.getResource();

```
### @Attachment/getContentType.m
```notalanguage
  GETCONTENTTYPE Gets the MIME content type of the attachment
  A character vector is returned.

```
### @Attachment/getId.m
```notalanguage
  GETID Gets the name of the resource
  A character vector is returned.

```
### @Attachment/getMediaLink.m
```notalanguage
  GETMEDIALINK Gets the media link associated with the attachment content
  A character vector is returned.

```
### @Attachment/getSelfLink.m
```notalanguage
  GETSELFLINK Gets the link of the resource
  Returns the link as a character vector

```
### @Attachment/setContentType.m
```notalanguage
  SETCONTENTTYPE Sets the content MIME type of the attachment content
 
  Example:
    myAttachment.setContentType('text/plain');

```
### @Attachment/setId.m
```notalanguage
  SETID Sets the name of the resource
 
  Example:
    attachment2.setId('myAttachmentId');

```
### @Attachment/setMediaLink.m
```notalanguage
  SETMEDIALINK Sets the media link associated with the attachment content
 
  Example:
    myAttachment.setMediaLink('www.mathworks.com');

```

------


## @DataType

### @DataType/DataType.m
```notalanguage
  DATATYPE Enumeration for data types in Cosmos DB.

```

------


## @Database

### @Database/Database.m
```notalanguage
  DATABASE Represents a Database in the Azure Cosmos DB database service
  A database manages users, permissions and a set of collections
  Each Azure Cosmos DB Service is able to support multiple independent named
  databases, with the database being the logical container for data.
  Each Database consists of one or more collections, each of which in turn
  contain one or more documents. Since databases are an an administrative
  resource and the Service Master Key will be required in order to access and
  successfully complete any action using the User APIs.
 
  If a database name is provided to the constructor rather than via the setId
  method a MATLAB struct is created with a field name of id for the name.
  This struct is then JSON encoded and used as the database name. Both
  approaches are equivalent.
  A database can also be created from a Java
  com.microsoft.azure.documentdb.Database object.

```
### @Database/getId.m
```notalanguage
  GETID Gets the name of the resource
  Returns the database Id as a character vector

```
### @Database/setId.m
```notalanguage
  SETID Sets the name of the resource
 
  Example:
    database = azure.documentdb.Database();
    database.setId('mydbname');
    docClient.createDatabase(database);

```

------


## @Document

### @Document/Document.m
```notalanguage
  DOCUMENT Represents a document in Azure Cosmos DB
  A document is a structured JSON document. There is no set schema for the JSON
  documents, and a document may contain any number of custom properties as well
  as an optional list of attachments. Document is an application resource and
  can be authorized using the master key or resource keys.
 
  Examples:
     azure.documentdb.Document(my_JSON_document_character_vector);
     % or
     azure.documentdb.Document();
     % or
     azure.documentdb.Document(myJavaDocumentObject)
 
     create a document in a collection
     documentContents = ['{' ,...
             '   "id": "test-document",' ,...
             '   "city" : "Galway",' ,...
             '   "population" : 79934', ' }' ] ;
     documentDefinition = azure.documentdb.Document(documentContents);
     disableAutomaticIdGeneration = false;
     documentResponse = docClient.createDocument(collectionLink, ...
                    documentDefinition, options, disableAutomaticIdGeneration);

```
### @Document/getDouble.m
```notalanguage
  GETDOUBLE Gets a double value for a given property
 
  Example:
    feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
    responseCellArray = feedResponse.getQueryCellArray();
    for n = 1:length(responseCellArray)
        disp(['id is ',responseCellArray{n}.getId()]);
        disp(['popularity is ', num2str(responseCellArray{n}.getDouble('popularity'))]);
    end

```
### @Document/getId.m
```notalanguage
  GETID Gets the name of the resource
  Returns the document Id as a character vector
 
  Example:
    feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
    responseCellArray = feedResponse.getQueryCellArray();
    for n = 1:length(responseCellArray)
        disp(['id is ',responseCellArray{n}.getId()]);
    end

```
### @Document/getInt.m
```notalanguage
  GETINT Gets an integer value for a given property
  Returns an int32
 
  Example:
     feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
     responseCellArray = feedResponse.getQueryCellArray();
     for n = 1:length(responseCellArray)
        disp(['count is ',num2str(responseCellArray{n}.getInt('count'))]);
     end

```
### @Document/getString.m
```notalanguage
  GETSTRING Gets a string value for a given property in character vector form
 
  Example:
    feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
    responseCellArray = feedResponse.getQueryCellArray();
    for n = 1:length(responseCellArray)
        disp(['city is ',responseCellArray{n}.getString('city')]);
    end

```
### @Document/setId.m
```notalanguage
  SETID Sets the name of the resource
 
  Example:
    mydocument = azure.documentdb.Document();
    mydocument.setId('mydocname');
    docClient.createDocument(mydocument);

```

------


## @DocumentClient

### @DocumentClient/DocumentClient.m
```notalanguage
  DOCUMENTCLIENT Client used to configure and execute requests
  Provides a client-side representation of the Azure Cosmos DB service.
  This client is used to configure and execute requests against the service.
  The service client holds the endpoint and credentials used to access
  the Azure Cosmos DB service.
 
  Example:
     % using default credentials
     database = azure.documentdb.Database('mydbname');
     docClient = azure.documentdb.DocumentClient()
     docClient.createDatabase(database);
     % or using paramters to speify connections details
     docClient = azure.documentdb.DocumentClient('serviceEndpoint', 'https://mycosmosaccount.documents.azure.com:443/', 'masterKey', 'p6iZa[MY REDACTED MASTER KEY]YZ7Q==')
     % or where a non default configuration file holding credentials is used
     docClient = azure.documentdb.DocumentClient('configurationFile', '/my/path/myconfigfile.json')

```
### @DocumentClient/close.m
```notalanguage
  CLOSE Closes a DocumentClient instance

```
### @DocumentClient/createAttachment.m
```notalanguage
  CREATEATTACHMENT Creates an attachment
  Returns a ResourceResponse.
 
  Example:
     %% create an attachment
     options = azure.documentdb.RequestOptions();
     documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
     body.id = 'image_id';
     body.contentType = 'image/jpg';
     body.media = 'www.mathworks.com';
     attachment = azure.documentdb.Attachment(jsonencode(body));
     attachmentResponse = docClient.createAttachment(documentLink, attachment, options);
 
 
     %% create a media stream based attachment
     % create sample data and write it to a file
     data = rand(10);
     tmpName = tempname;
     dlmwrite(tmpName, data);
 
     % configure attachment option settings
     mediaOptions = azure.documentdb.MediaOptions();
     slug = 'myAttachmentId';
     % writing the data in ascii format in this case
     contentType = 'text/plain';
     mediaOptions.setSlug(slug);
     mediaOptions.setContentType(contentType);
 
     % create the attachment in Cosmos DB and get the response
     attachmentResponse = docClient.createAttachment(documentLink, tmpName, mOptions);
     attachmentResource = attachmentResponse.getResource();

```
### @DocumentClient/createCollection.m
```notalanguage
  CREATECOLLECTION Creates a document collection
  Returns a ResourceResponse.
 
  Example:
     docClient = azure.documentdb.DocumentClient()
     database = azure.documentdb.Database('mydbname');
     docClient.createDatabase(database);
     databaseLink = ['/dbs/',database.getId()];
     myCollection = azure.documentdb.DocumentCollection('mycollectionname');
     docClient.createCollection(databaseLink, myCollection);

```
### @DocumentClient/createDatabase.m
```notalanguage
  CREATEDATABASE Creates a database
  The database name or Id must have been set prior to creating the Database in
  Cosmos DB, either at declaration or with a subsequent setId() call.
  Returns a ResourceResponse.
 
  Example:
    options = azure.documentdb.RequestOptions();
    database = azure.documentdb.Database('mydbname');
    docClient.createDatabase(database, options);
    % or
    options = azure.documentdb.RequestOptions();
    database = azure.documentdb.Database();
    database.setId('mydbname');
    docClient.createDatabase(database, options);

```
### @DocumentClient/createDocument.m
```notalanguage
  CREATEDOCUMENT Creates a document
  Creation using POJO is not currently supported.
  Returns a ResourceResponse.
 
  Example:
    % create a document in a collection
    collectionLink = documentCollection.getSelfLink();
    documentContents = ['{' ,...
                 '   "id": "test-document",' ,...
                 '   "city" : "Galway",' ,...
                 '   "population" : 79934', ' }' ] ;
    documentDefinition = azure.documentdb.Document(documentContents);
    disableAutomaticIdGeneration = false;
    documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);

```
### @DocumentClient/createStoredProcedure.m
```notalanguage
  CREATESTOREDPROCEDURE Creates a stored procedure
  Returns a ResourceResponse.
 
  Examples:
      % Execute Stored Procedure with Arguments
      storedProcedureStr = ['{' ,...
         '  "id" : "multiplySample",' ,...
         '  "body" : ' ,...
         '    "function (value, num) {' ,...
         '       getContext().getResponse().setBody(\"2*\" + value + \" is \" + num * 2);' ,...
         '     }"' ,...
         '}'];
      storedProcedure =  azure.documentdb.StoredProcedure(storedProcedureStr);
      docClient.createStoredProcedure(collectionLink, storedProcedure, options);
 
      Note the id and body can be struct members and JSON encoded by MATLAB
      alternatively. This is less error prone regarding escaping special
      characters etc.
 
      storedProcedureStruct.id = 'storedProcedureSample'
      storedProcedureStruct.body = ['function() {' ,...
         '        var mytext = "x";' ,...
         '        var myval = 1;' ,...
         '        try {' ,...
         '            console.log("The value of %s is %s.", mytext, myval);' ,...
         '            getContext().getResponse().setBody("Success!");' ,...
         '        }' ,...
         '        catch(err) {' ,...
         '            getContext().getResponse().setBody("inline err: [" + err.number + "] " + err);' ,...
         '        }' ,...
         '     }']
      storedProcedureStr = jsonencode(storedProcedureStruct)

```
### @DocumentClient/createTrigger.m
```notalanguage
  CREATEDOCUMENT Creates a trigger
  Returns a ResourceResponse.
 
  Example:
     % create trigger
     triggerId = 'mytriggerexample';
     trigger = azure.documentdb.Trigger();
     trigger.setId(triggerId);
     triggerBody = ['function testTrigger() {',...
         ' var context = getContext();' ,...
         ' var request = context.getRequest();' ,...
         ' var myDocument = request.getBody();' ,...
         ' myDocument["myTest"] = "Created by createTrigger";' ,...
         ' request.setBody(myDocument);' ,...
     '}'];
     trigger.setBody(triggerBody);
     trigger.setTriggerType(azure.documentdb.TriggerType.Pre);
     trigger.setTriggerOperation(azure.documentdb.TriggerOperation.Delete);
     docClient.createTrigger(collectionLink, trigger, options);

```
### @DocumentClient/createUserDefinedFunction.m
```notalanguage
  CREATEUSERDEFINEDFUNCTION Creates a User Defined Function
  Returns a ResourceResponse.
 
  Examples:
  TODO

```
### @DocumentClient/deleteAttachment.m
```notalanguage
  DELETEATTACHMENT Deletes an attachment
  Returns a ResourceResponse.

```
### @DocumentClient/deleteCollection.m
```notalanguage
  DELETECOLLECTION Deletes a document collection by the collection link
  Returns a ResourceResponse.

```
### @DocumentClient/deleteDatabase.m
```notalanguage
  DELETEDATABASE Deletes a database
  The database to delete is identified using a database link, this is the
  the Id proceeded by a path like string.
  Returns a ResourceResponse.
 
  Example:
     options = azure.documentdb.RequestOptions();
     databaseLink = ['/dbs/',database.getId()];
     docClient.deleteDatabase(databaseLink, options)

```
### @DocumentClient/deleteDocument.m
```notalanguage
  DELETEDOCUMENT Deletes a document by the document link
  Returns a ResourceResponse.

```
### @DocumentClient/deleteStoredProcedure.m
```notalanguage
  DELETESTOREDPROCEDURE Deletes a stored procedure
  Returns a ResourceResponse.

```
### @DocumentClient/deleteTrigger.m
```notalanguage
  DELETETRIGGER Deletes a trigger by the trigger link
  Returns a ResourceResponse.

```
### @DocumentClient/deleteUserDefinedFunction.m
```notalanguage
  DELETEUSERDEFINEDFUNCTION Deletes a User Defined Function
  Returns a ResourceResponse.

```
### @DocumentClient/executeStoredProcedure.m
```notalanguage
  GETSTOREDPROCEDURES Executes a stored procedure using the procedure's link
  A azure.documentdb.StoredProcedureResponse object is returned.
  If no procedure parameters are required an empty cell array {} can be
  passed.
  Returns a StoredProcedureResponse.
 
  Example:
     storedProcedure =  azure.documentdb.StoredProcedure(storedProcedureStr);
     docClient.createStoredProcedure(collectionLink, storedProcedure, options);
     storedProcLink = ['/dbs/',databaseId,'/colls/', collectionId,'/sprocs/','storedProcedureSample'];
     requestOptions = azure.documentdb.RequestOptions();
     requestOptions.setScriptLoggingEnabled(true);
     requestOptions.setPartitionKey(azure.documentdb.PartitionKey('myKey'));
     storedProcedureResponse = docClient.executeStoredProcedure(storedProcLink, requestOptions, {});

```
### @DocumentClient/existsDatabase.m
```notalanguage
  EXISTSDATABASE Tests if a database exists or not
  Returns true if the database exists otherwise false. Existence is determined
  by calling readDatabase() if the read fails with a "Resource Not Found"
  exception false is returned otherwise true is returned. Thus true may be
  returned in the case of other exceptions even if the database does not exist.

```
### @DocumentClient/existsUserDefinedFunction.m
```notalanguage
  EXISTSUSERDEFINEDFUNCTION Tests if a UDF exists or not
  Returns true if the database exists otherwise false. Existence is determined
  by calling readUserDefinedFunction() if the read fails with a "Resource Not Found"
  exception false is returned otherwise true is returned. Thus true may be
  returned in the case of other exceptions even if the database does not exist.

```
### @DocumentClient/loadConfigurationSettings.m
```notalanguage
  LOADCONFIGURATIONSETTINGS read DocumentClient configuration file
  By default the configuration file is called: documentdb.json
  or the name can be specified as an argument. If account configuration settings
  are not provided the locally hosted development account will be used.

```
### @DocumentClient/queryAttachments.m
```notalanguage
  QUERYATTACHMENT Query for attachments
  Returns a FeedResponse.
 
  Example:
     feedResponse = docClient.queryAttachments(documentLink, 'SELECT * from r', feedOptions);

```
### @DocumentClient/queryCollections.m
```notalanguage
  QUERYCOLLECTION Query for document collections in a database
  Returns a FeedResponse
 
  Example:
     feedOptions = azure.documentdb.FeedOptions();
     queryStr = ['SELECT * FROM r where r.id = ''', collectionId,''''];
     queryResults = docClient.queryCollections(databaseLink, queryStr, feedOptions);
     responseCellArray = queryResults.getQueryCellArray();

```
### @DocumentClient/queryDatabases.m
```notalanguage
  QUERYDATABASES Query for databases
  Returns a FeedResponse.
 
  Example:
     feedOptions = azure.documentdb.FeedOptions();
     queryStr = ['SELECT * FROM r where r.id = ''', databaseId,''''];
     queryResults = docClient.queryDatabases(queryStr, feedOptions);

```
### @DocumentClient/queryDocuments.m
```notalanguage
  QUERYDOCUMENTS Query for documents in a document collection
  Returns a FeedResponse.
 
  Example:
     feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
     responseCellArray = feedResponse.getQueryCellArray();

```
### @DocumentClient/queryOffers.m
```notalanguage
  QUERYOFFERS Query for offers in a database
  Returns a FeedResponse.
 
  Example:
     queryStr = ['SELECT * FROM c where c.offerResourceId = ''', documentCollection.getResourceId(),''''];
     feedOptions = azure.documentdb.FeedOptions();
     offersFeedResponse = docClient.queryOffers(queryStr, feedOptions);

```
### @DocumentClient/queryStoredProcedures.m
```notalanguage
  QUERYSTOREDPROCEDURES Query for stored procedures in a document collection
  Returns a FeedResponse.

```
### @DocumentClient/queryTriggers.m
```notalanguage
  QUERYTRIGGERS Query for triggers
  Returns a FeedResponse.
 
  Example:
    feedOptions = azure.documentdb.FeedOptions();
    queryStr = ['SELECT * FROM r where r.id = ''', triggerId,''''];
    queryResults = docClient.queryTriggers(collectionLink, queryStr, feedOptions);
    responseCellArray = queryResults.getQueryCellArray();

```
### @DocumentClient/queryUserDefinedFunctions.m
```notalanguage
  QUERYUSERDEFINEDFUNCTIONS Query for user defined functions.
  Returns a FeedResponse.

```
### @DocumentClient/readAttachment.m
```notalanguage
  READATTACHMENT Reads an attachment
  Returns a ReourceResponse.
 
  Example:
     attachmentLink = attachmentResource.getSelfLink();
     readResponse = docClient.readAttachment(attachmentLink, options);
     readAttachment = readResponse.getResource();

```
### @DocumentClient/readAttachments.m
```notalanguage
  READATTACHMENTS Reads all attachments in a document
  Returns a FeedResponse.
 
  Example:
     feedOptions = azure.documentdb.FeedOptions();
     readResponses = docClient.readAttachments(documentLink, feedOptions);
     responseCellArray = readResponses.getQueryCellArray();

```
### @DocumentClient/readCollection.m
```notalanguage
  READCOLLECTION Reads a document collection by the collection link
  Returns a ReourceResponse.
 
  Example:
     options = azure.documentdb.RequestOptions();
     documentCollection = collectionResponse.getResource();
     collectionLink = documentCollection.getSelfLink();
     readResponse = docClient.readCollection(collectionLink, options);
     readCollection = readResponse.getResource();

```
### @DocumentClient/readCollections.m
```notalanguage
  READCOLLECTIONS Reads all document collections in a database
 
  Example:
  TODO

```
### @DocumentClient/readDatabase.m
```notalanguage
  READDATABASE Reads a database
 
  Example:
     options = azure.documentdb.RequestOptions();
     databaseLink = ['/dbs/',database.getId()];
     readResponse = docClient.readDatabase(databaseLink, options);
     readResult = readResponse.getResource();

```
### @DocumentClient/readDocument.m
```notalanguage
  READDOCUMENT Reads a document by the document link
 
  Example:
     documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
     % assuming a multi partition collection, partition key has to be provided
     options = azure.documentdb.RequestOptions();
     options.setPartitionKey(azure.documentdb.PartitionKey('Galway'));
     % read document using the collectionlink and the provided partition key
     response = docClient.readDocument(documentLink, options);
     % access request charge associated with document read
     % access individual fields
     readDocument = response.getResource();

```
### @DocumentClient/readDocuments.m
```notalanguage
  READDOCUMENTS Reads all documents in a document collection.

```
### @DocumentClient/readMedia.m
```notalanguage
  READMEDIA Reads media by the media link
  Returns a MediaResponse.

```
### @DocumentClient/readStoredProcedure.m
```notalanguage
  READSTOREDPROCEDURE Read a stored procedure by the stored procedure link
  Returns a ResourceResponse.

```
### @DocumentClient/readStoredProcedures.m
```notalanguage
  READSTOREDPROCEDURES Reads all stored procedures in a document collection link
  Returns a FeedResponse.

```
### @DocumentClient/readTrigger.m
```notalanguage
  READTRIGGER Reads a trigger by the trigger link.
  Returns a ReourceResponse.

```
### @DocumentClient/readTriggers.m
```notalanguage
  READTRIGGERS Reads all triggers in a document collection
  Returns a FeedResponse.

```
### @DocumentClient/readUserDefinedFunction.m
```notalanguage
  READUSERDEFINEDFUNCTION Read a user defined function
  Returns a ReourceResponse.

```
### @DocumentClient/readUserDefinedFunctions.m
```notalanguage
  READUSERDEFINEDFUNCTIONS Reads all user defined functions in a document collection
  Returns a FeedResponse.

```
### @DocumentClient/replaceOffer.m
```notalanguage
  REPLACEOFFER Replaces an offer
  Returns a ReourceResponse.

```
### @DocumentClient/upsertAttachment.m
```notalanguage
  UPSERTATTACHMENT Upserts an attachment to a document
  Upsert provides an atomically safe alternative to a create or replace
  operation preceded by a read.
  Returns a ReourceResponse.
 
  Example:
     documentLink = ['/dbs/',databaseId,'/colls/',collectionId,'/docs/','test-document'];
     % create attachment
     body.id = 'image_id';
     body.contentType = 'image/jpg';
     body.media = 'www.mathworks.com';
     attachment = azure.documentdb.Attachment(jsonencode(body));
     attachmentResponse = docClient.upsertAttachment(documentLink, attachment, options);
     attachmentResource = attachmentResponse.getResource();

```
### @DocumentClient/upsertDocument.m
```notalanguage
  UPSERTDOCUMENT Upserts a document to a collection
  Upsert provides an atomically safe alternative to a create or replace
  operation preceded by a read.
  Returns a ReourceResponse.
 
  Example:
     create a document in the collection
     documentContents = ['{' ,...
                 '   "id": "test-document",' ,...
                 '   "city" : "Galway",' ,...
                 '   "population" : 79934', ' }' ] ;
     documentDefinition = azure.documentdb.Document(documentContents);
     disableAutomaticIdGeneration = false;
     % upsert the document to the database
     documentResponse = docClient.upsertDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);

```

------


## @DocumentCollection

### @DocumentCollection/DocumentCollection.m
```notalanguage
  DOCUMENTCOLLECTION Represents a document collection in Cosmos DB
  A collection contains documents. A database may contain zero or more
  collections and each collection consists of zero or more JSON documents.
  The documents in a collection do not need to share the same structure.
 
  Example:
     azure.documentdb.DocumentCollection('mycollectionname');
     % or
     azure.documentdb.DocumentCollection();
     % or using a Java com.microsoft.azure.documentdb.DocumentCollection object
     azure.documentdb.DocumentCollection(myDocumentCollectionObject)

```
### @DocumentCollection/getId.m
```notalanguage
  GETID Gets the name of the resource
  Returns the collection Id as a character vector

```
### @DocumentCollection/getResourceId.m
```notalanguage
  GETRESOURCEID Gets the name of the resource
  Returns a character vector.

```
### @DocumentCollection/getSelfLink.m
```notalanguage
  GETSELFLINK Gets the link of the resource
  Returns the collectionLink as a character vector

```
### @DocumentCollection/setId.m
```notalanguage
  SETID Sets the name of the resource
 
  Example:
     collection = azure.documentdb.DocumentCollection();
     collection.setId('mycollection');

```
### @DocumentCollection/setIndexingPolicy.m
```notalanguage
  SETINDEXINGPOLICY Sets Sets the indexing policy
 
  Example:
     % create the collection
     collectionDefinition = azure.documentdb.DocumentCollection();
     collectionId = 'mycollectionname';
     collectionDefinition.setId(collectionId);
     % set indexing policy to be range range for string and number
     indexingPolicy = azure.documentdb.IndexingPolicy();
     includedPath = azure.documentdb.IncludedPath();
     includedPath.setPath('/*');
     stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
     numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
     indexes = {stringRangeIndex, numberRangeIndex};
     includedPath.setIndexes(indexes);
     includedPaths = {includedPath};
     indexingPolicy.setIncludedPaths(includedPaths);
     collectionDefinition.setIndexingPolicy(indexingPolicy);

```
### @DocumentCollection/setPartitionKey.m
```notalanguage
  SETPARTITIONKEY Sets the collection's partition key definition
 
  Example:
     % create the collection
     collectionDefinition = azure.documentdb.DocumentCollection();
     collectionId = 'mycollectionname';
     collectionDefinition.setId(collectionId);
     % Set /city as the partition key path
     partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
     partitionKeyFieldName = 'city';
     partitionKeyPath = ['/' , partitionKeyFieldName];
     paths = [string(partitionKeyPath)];
     partitionKeyDefinition.setPaths(paths);
     collectionDefinition.setPartitionKey(partitionKeyDefinition);

```

------


## @FeedOptions

### @FeedOptions/FeedOptions.m
```notalanguage
  FEEDOPTIONS Options associated with feed methods in Cosmos DB
 
  Examples:
     azure.documentdb.FeedOptions();
     % or using a com.microsoft.azure.documentdb.FeedOptions object
     azure.documentdb.FeedOptions(myFeedOptionsObject)

```
### @FeedOptions/setEnableCrossPartitionQuery.m
```notalanguage
  SETENABLECROSSPATITIONQUERY Allows queries across all collection partitions

```

------


## @FeedResponse

### @FeedResponse/FeedResponse.m
```notalanguage
  FEEDRESPONSE Used by feed methods (enumeration operations) in Cosmos DB
  DocumentClient methods that return multiple response will in general return a
  FeedResponse object from which the resources can be retrieved.

```
### @FeedResponse/getQueryCellArray.m
```notalanguage
  GETQUERYCELLARRAY Convert feedResponse Java collection to a cell array
  This method can be used as an alternative to code like the following:
 
    feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
    iteratorJ = feedResponse.Handle.getQueryIterator();
    while iteratorJ.hasNext()
        d = azure.documentdb.Document(iteratorJ.next());
    end
 
  It returns the results as a cell array rather than requiring the Java iterator
  If the feedResponse contains objects of type: Database, DocumentCollection,
  Document, Attachment, Offer, Trigger, StoredProcedure or UserDefinedFunction
  They will be returned as MATLAB objects otherwise the underlying Java object
  will be returned.

```

------


## @IncludedPath

### @IncludedPath/IncludedPath.m
```notalanguage
  INCLUDEDPATH Creates an instance of an IncludedPath when setting IndexingPolicy
 
  Example:
     % set indexing policy to be range range for string and number
     indexingPolicy = azure.documentdb.IndexingPolicy();
     includedPath = azure.documentdb.IncludedPath();
     includedPath.setPath('/*');
     stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
     numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
     indexes = {stringRangeIndex,numberRangeIndex};
     includedPath.setIndexes(indexes);
     % in this case only one path is set, more than one path may be set
     includedPaths = {includedPath};
     indexingPolicy.setIncludedPaths(includedPaths);

```
### @IncludedPath/setIndexes.m
```notalanguage
  SETINDEXES Sets indexes for an includedPath
 
  Example:
     includedPath = azure.documentdb.IncludedPath();
     includedPath.setPath('/*');
     stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
     numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
     indexes = {stringRangeIndex,numberRangeIndex};
     includedPath.setIndexes(indexes);
     includedPaths = {includedPath};
     indexingPolicy.setIncludedPaths(includedPaths);

```
### @IncludedPath/setPath.m
```notalanguage
  SETPATH Sets a path in an IncludedPath object

```

------


## @IndexKind

### @IndexKind/IndexKind.m
```notalanguage
  IndexKind Enumeration for the kinds of Index
 
  Example:
     numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);

```

------


## @IndexingPolicy

### @IndexingPolicy/IndexingPolicy.m
```notalanguage
  INDEXINGPOLICY Options associated with feed methods in Cosmos DB
 
  Examples:
     azure.documentdb.IndexingPolicy();
     % or using a Java com.microsoft.azure.documentdb.IndexingPolicy object
     azure.documentdb.IndexingPolicy(myIndexingPolicyObject)
     % or using a JSON character vector
     azure.documentdb.IndexingPolicy(myJSONCharacterVector)

```
### @IndexingPolicy/setIncludedPaths.m
```notalanguage
  SETINCLUDEDPATHS Sets Included paths for an indexingPolicy
 
  Example:
     includedPaths = {includedPath};
     indexingPolicy.setIncludedPaths(includedPaths);

```

------


## @MediaOptions

### @MediaOptions/MediaOptions.m
```notalanguage
  MEDIAOPTIONS Initialize a MediaOptions object
 
  Example:

```
### @MediaOptions/getContentType.m
```notalanguage
  GETCONTENTTYPE Gets the HTTP ContentType header value
  Returns a character vector

```
### @MediaOptions/getSlug.m
```notalanguage
  GETSLUG Gets the HTTP Slug header value
  Returns a character vector

```
### @MediaOptions/setContentType.m
```notalanguage
  SETCONTENTTYPE Sets the HTTP ContentType header value
  contentType should be of type character vector

```
### @MediaOptions/setSlug.m
```notalanguage
  SETSLUG Sets the HTTP Slug header value
  slug should be of type character vector

```

------


## @MediaResponse

### @MediaResponse/MediaResponse.m
```notalanguage
  MEDIARESPONSE Response associated with retrieving attachment content

```
### @MediaResponse/getMedia.m
```notalanguage
  GETMEDIA Gets the attachment content stream and writes it to a file
  True is returned on successful completion

```
### @MediaResponse/getResponseHeaders.m
```notalanguage
  GETRESPONSEHEADERS Gets the headers associated with the response
  Returns a containers.Map object. If there are no headers an empty
  containers.Map is returned.

```

------


## @Offer

### @Offer/Offer.m
```notalanguage
  OFFER Initialize an offer object
 
  Example:
     queryStr = ['SELECT * FROM c where c.offerResourceId = ''', documentCollection.getResourceId(),''''];
     feedOptions = azure.documentdb.FeedOptions();
     offersFeedResponse = docClient.queryOffers(queryStr, feedOptions);
     offerIteratorJ = offersFeedResponse.Handle.getQueryIterator();
     offer = azure.documentdb.Offer(offerIteratorJ.next());
     % returns a Java JSON object
     contentJSON = offer.getContent();

```
### @Offer/getContent.m
```notalanguage
  GETCONTENT Gets the content object that contains the details of the offer
  Returns a Java JSONObject

```
### @Offer/setContent.m
```notalanguage
  SETCONTENT Sets the offer content that contains the details of the offer

```

------


## @PartitionKey

### @PartitionKey/PartitionKey.m
```notalanguage
  PARTITIONKEY Represents a partition key value in Cosmos DB
  A partition key identifies the partition where the document is stored.
 
  Example:
     requestOptions = azure.documentdb.RequestOptions();
     requestOptions.setScriptLoggingEnabled(true);
     requestOptions.setPartitionKey(azure.documentdb.PartitionKey('Galway'));

```

------


## @PartitionKeyDefinition

### @PartitionKeyDefinition/PartitionKeyDefinition.m
```notalanguage
  PARTITIONKEYDEFINITION Creates a new instance of a PartitionKeyDefinition
 
  Example:
     % set /city as the partition key path
     partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
     partitionKeyFieldName = 'city';
     partitionKeyPath = ['/' , partitionKeyFieldName];
     paths = string(partitionKeyPath);
     partitionKeyDefinition.setPaths(paths);
     collectionDefinition.setPartitionKey(partitionKeyDefinition);

```
### @PartitionKeyDefinition/setPaths.m
```notalanguage
  SETPATHS Sets paths in a partition key definition
  paths are passed in as a MATLAB string array
 
  Example:
     partitionKeyPath = ['/' , partitionKeyFieldName];
     paths = string(partitionKeyPath);
     partitionKeyDefinition.setPaths(paths);

```

------


## @RangeIndex

### @RangeIndex/RangeIndex.m
```notalanguage
  RANGEINDEX Represents a range index in Cosmos DB
 
  Examples:
     stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
     numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
     indexes = {stringRangeIndex,numberRangeIndex};
     includedPath.setIndexes(indexes);

```
### @RangeIndex/setDataType.m
```notalanguage
  SETDATATYPE

```
### @RangeIndex/setPrecision.m
```notalanguage
  SETPRECISION Sets precision, input converted to an int32

```

------


## @RequestOptions

### @RequestOptions/RequestOptions.m
```notalanguage
  REQUESTOPTIONS Options for a request issued to the database service
 
  Example:
     options = azure.documentdb.RequestOptions();
     options.setOfferThroughput(400);
     docClient.createCollection(databaseLink, myCollection, options);

```
### @RequestOptions/setOfferThroughput.m
```notalanguage
  SETOFFERTHROUGHPUT Sets throughput in Request Units per second
  This can be used when creating a document collection.
 
  Example:
     options = azure.documentdb.RequestOptions();
     options.setOfferThroughput(400);
     docClient.createCollection(databaseLink, myCollection, options);

```
### @RequestOptions/setPartitionKey.m
```notalanguage
  SETPARTITIONKEY Sets partition key to identify the request's target partition
 
  Example:
     partitionKeyDefinition = azure.documentdb.PartitionKeyDefinition();
     partitionKeyFieldName = 'city';
     partitionKeyPath = ['/' , partitionKeyFieldName];
     paths = string(partitionKeyPath);
     partitionKeyDefinition.setPaths(paths);
     collectionDefinition.setPartitionKey(partitionKeyDefinition);

```
### @RequestOptions/setScriptLoggingEnabled.m
```notalanguage
  SETSCRIPTLOGGINGENABLED Enables stored procedure logging
  Sets whether Javascript stored procedure logging is enabled for the current
  request in or not.

```

------


## @ResourceResponse

### @ResourceResponse/ResourceResponse.m
```notalanguage
  RESOURCERESPONSE Represents response to a request made from DocumentClient
  in Cosmos DB database service. It contains both the resource and the response
  headers.

```
### @ResourceResponse/getRequestCharge.m
```notalanguage
  GETREQUESTCHARGE Gets number of index paths (terms) generated by the operation
  Returns a double

```
### @ResourceResponse/getResource.m
```notalanguage
  GETRESOURCE Gets the resource for the request
  Returns an object of the type represented by the Response

```

------


## @SqlQuerySpec

### @SqlQuerySpec/SqlQuerySpec.m
```notalanguage
  SQLQUERYSPEC Represents a SQL query in Azure Cosmos DB
 
  Example:
     azure.documentdb.SqlQuerySpec(my_SqlQuerySpec_query_text);
     or
     azure.documentdb.SqlQuerySpec();
     or
     azure.documentdb.SqlQuerySpec(mySqlQuerySpecObject)

```

------


## @StoredProcedure

### @StoredProcedure/StoredProcedure.m
```notalanguage
  STOREDPROCEDURE Represents a a stored procedure in Azure Cosmos DB
  Cosmos DB allows stored procedures to be executed in the storage tier,
  against a document collection. The procedure is executed under ACID
  transactions on the primary storage partition of the specified collection.
  The procedure should be valid JSON as a character vector. One can compare the
  following with equivalent Java code here:
  https://github.com/Azure/azure-documentdb-java/blob/master/documentdb-examples/src/test/java/com/microsoft/azure/documentdb/examples/StoredProcedureSamples.java
 
  Example:
     storedProcedureStr = ['{' ,...
      '  "id" : "storedProcedureSample",' ,...
      '  "body" : ',...
      '    "function() {' ,...
      '        var mytext = \"x\";' ,...
      '        var myval = 1;' ,...
      '        try {' ,...
      '            console.log(\"The value of %s is %s.\", mytext, myval);' ,...
      '            getContext().getResponse().setBody(\"Success!\");' ,...
      '        }' ,...
      '        catch(err) {' ,...
      '            getContext().getResponse().setBody(\"inline err: [\" + err.number + \"] \" + err);' ,...
      '        }' ,...
      '     }"',...
      '}'];
     storedProcedure =  azure.documentdb.StoredProcedure(storedProcedureStr);
     docClient.createStoredProcedure(collectionLink, storedProcedure, options);
     storedProcLink = ['/dbs/',databaseId,'/colls/', collectionId,'/sprocs/','storedProcedureSample'];
 
  % Constructor options:
     azure.documentdb.StoredProcedure(<StoredProcedure JSON character vector>);
     or
     azure.documentdb.StoredProcedure();
     or
     azure.documentdb.StoredProcedure(myStoredProcedureObject)

```
### @StoredProcedure/getBody.m
```notalanguage
  GETBODY Returns the the body of the stored procedure
  Returns a character vector.

```
### @StoredProcedure/getId.m
```notalanguage
  GETID Gets the name of the resource
  Returns the procedure Id as a character vector

```
### @StoredProcedure/setBody.m
```notalanguage
  SETBODY Set the body of the stored procedure
  Body argument should be a character vector

```

------


## @StoredProcedureResponse

### @StoredProcedureResponse/StoredProcedureResponse.m
```notalanguage
  STOREDPROCEDURERESPONSE Represents response from a stored procedure
  This object wraps the response body and headers.

```
### @StoredProcedureResponse/getResponseAsString.m
```notalanguage
  GETRESPONSEASSTRING Gets response of a stored procedure as a character vector

```
### @StoredProcedureResponse/getResponseHeaders.m
```notalanguage
  GETRESPONSEHEADERS Gets the headers associated with the response
  Returns a containers.Map object. If there are no headers an empty
  containers.Map is returned.

```
### @StoredProcedureResponse/getScriptLog.m
```notalanguage
  GETSCRIPTLOG Gets the output from stored procedure console.log() statements
  Returns a character vector.

```

------


## @Trigger

### @Trigger/Trigger.m
```notalanguage
  TRIGGER Represents a trigger in Cosmos DB
  Cosmos DB supports pre and post triggers defined in JavaScript to be executed
  on creates, updates and deletes.
 
  Example:
     triggerId = 'mytriggerexample';
     trigger = azure.documentdb.Trigger();
     trigger.setId(triggerId);
     triggerBody = ['function testTrigger() {',...
         ' var context = getContext();' ,...
         ' var request = context.getRequest();' ,...
         ' var myDocument = request.getBody();' ,...
         ' myDocument["myTest"] = "Created by createTrigger";' ,...
         ' request.setBody(myDocument);' ,...
     '}'];
     trigger.setBody(triggerBody);
     trigger.setTriggerType(azure.documentdb.TriggerType.Pre);
     trigger.setTriggerOperation(azure.documentdb.TriggerOperation.Delete);
     docClient.createTrigger(collectionLink, trigger, options);
 
  Constructor options:
     azure.documentdb.Trigger('mytriggername');
     or
     azure.documentdb.Trigger();
     or
     azure.documentdb.Trigger(myJavaTriggerObject)

```
### @Trigger/getBody.m
```notalanguage
  GETBODY Get the body of the trigger
  Returns a character vector.

```
### @Trigger/getId.m
```notalanguage
  GETID Gets the name of the resource
  Returns the trigger Id as a character vector

```
### @Trigger/getTriggerOperation.m
```notalanguage
  GETTRIGGEROPERATION Get the operation type of the trigger
  Returns a TriggerOperation object.

```
### @Trigger/getTriggerType.m
```notalanguage
  GETTRIGGERTYPE Get the type of the trigger
  Returns a TriggerType object.

```
### @Trigger/setBody.m
```notalanguage
  SETBODY Set the body of the trigger
  Body should be a character vector, it should not be JSON encoded

```
### @Trigger/setId.m
```notalanguage
  SETID Sets the name of the resource
 
  Example:
     trigger = azure.documentdb.Trigger();
     trigger.setId('mytrigger');

```
### @Trigger/setTriggerOperation.m
```notalanguage
  SETTRIGGEROPERATION Set the operation type of the trigger

```
### @Trigger/setTriggerType.m
```notalanguage
  SETTRIGGERTYPE Set the type of the trigger

```

------


## @TriggerOperation

### @TriggerOperation/TriggerOperation.m
```notalanguage
  TRIGGERTYPE Enumeration of trigger operation types

```

------


## @TriggerType

### @TriggerType/TriggerType.m
```notalanguage
  TRIGGERTYPE Enumeration of trigger types

```

------


## @UserDefinedFunction

### @UserDefinedFunction/UserDefinedFunction.m
```notalanguage
  USERDEFINEDFUNCTION Represents a user defined function in Cosmos
  DB supports JavaScript UDFs which can be used inside queries, stored
  procedures and triggers. See the Cosmos DB server-side JavaScript API
  documentation for further details.
 
  Example:
      % create a database
      databaseId = 'unittestcosmosdb';
      database = azure.documentdb.Database(databaseId);
      databaseLink = ['/dbs/',database.getId()];
      docClient = azure.documentdb.DocumentClient();
      options = azure.documentdb.RequestOptions();
      docClient.createDatabase(database, options);
 
      % create a collection
      collectionDefinition = azure.documentdb.DocumentCollection();
      collectionDefinition.setId('Incomes');
      collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
      documentCollection = collectionResponse.getResource();
      collectionLink = documentCollection.getSelfLink();
 
      % create a document
      documentContents = ['{ '...
      '"name" : "Joe Blog", '...
      '"country" : "USA", '...
      '"income" : 70000'...
      '}'];
      documentDefinition = azure.documentdb.Document(documentContents);
      disableAutomaticIdGeneration = false;
      documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);
 
      % Create the JavaScript code the UDF runs, could also be read from a file
      jsCode = ['function tax(income) { '...
                  'if(income == undefined) '...
                  '  throw ''no input''; '...
                  'if (income < 1000) '...
                  '  return income * 0.1; ' ...
                  'else if (income < 10000) '...
                  '  return income * 0.2; '...
                  'else '...
                  '  return income * 0.4; '...
               '}'];
 
      % create a collectionLink and then the UDF
      containerLink = ['/dbs/',databaseId,'/colls/','Incomes'];
      myUDF = azure.documentdb.UserDefinedFunction();
      myUDF.setId('udfTax');
      myUDF.setBody(jsCode);
      createdUDF = docClient.createUserDefinedFunction(collectionLink, myUDF, options);
 
      % query the UDF
      feedOptions = azure.documentdb.FeedOptions();
      feedResponse = docClient.queryUserDefinedFunctions(collectionLink, 'SELECT * from r', feedOptions);
      responseCellArray = feedResponse.getQueryCellArray();
 
      % read the udf
      udfLink = [containerLink, '/', 'udfs/',myUDF.getId()];
      readResponse = docClient.readUserDefinedFunction(udfLink, options);
      readResult = readResponse.getResource();
 
      % read more than one udf if present
      feedResponse = docClient.readUserDefinedFunctions(collectionLink, feedOptions);
      responseCellArray = feedResponse.getQueryCellArray();
      testCase.verifyEqual(char(responseCellArray{1}.getId()), myUDF.getId());
 
      % invoke the UDF
      feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * FROM Incomes t WHERE udf.udfTax(t.income) > 20000', feedOptions);
      responseCellArray = feedResponse.getQueryCellArray();
 
      % cleanup, delete the collection & database
      docClient.deleteCollection(collectionLink, options);
      docClient.deleteDatabase(databaseLink, options);
      docClient.close;
 
 
  Constructor options:
      azure.documentdb.UserDefinedFunction('myudfname');
       or
      azure.documentdb.UserDefinedFunction();
       or
      azure.documentdb.UserDefinedFunction(myJavaUdfObject)

```
### @UserDefinedFunction/getBody.m
```notalanguage
  GETBODY Get the body of the UDF
  Returns a character vector.

```
### @UserDefinedFunction/getId.m
```notalanguage
  GETID Gets the name of the resource
  Returns the trigger Id as a character vector

```
### @UserDefinedFunction/setBody.m
```notalanguage
  SETBODY Set the body of the UDF
  Body should be a character vector, it should not be JSON encoded

```
### @UserDefinedFunction/setId.m
```notalanguage
  SETID Sets the name of the resource
 
  Example:
     myUDF = azure.documentdb.UserDefinedFunction();
     myUDF.setId('myUDFName');

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
### functions/azCosmosDBRoot.m
```notalanguage
  AZCOSMOSDBROOT Helper function to locate the Azure Cosmos DB interface
 
  Locate the installation of the Azure tooling to allow easier construction
  of absolute paths to the required dependencies.



```



------------    

[//]: # (Copyright 2019 The MathWorks, Inc.)
