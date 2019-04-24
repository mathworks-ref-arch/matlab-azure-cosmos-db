classdef UserDefinedFunction < azure.object
% USERDEFINEDFUNCTION Represents a user defined function in Cosmos
% DB supports JavaScript UDFs which can be used inside queries, stored
% procedures and triggers. See the Cosmos DB server-side JavaScript API
% documentation for further details.
%
% Example:
%     % create a database
%     databaseId = 'unittestcosmosdb';
%     database = azure.documentdb.Database(databaseId);
%     databaseLink = ['/dbs/',database.getId()];
%     docClient = azure.documentdb.DocumentClient();
%     options = azure.documentdb.RequestOptions();
%     docClient.createDatabase(database, options);
% 
%     % create a collection
%     collectionDefinition = azure.documentdb.DocumentCollection();
%     collectionDefinition.setId('Incomes');
%     collectionResponse = docClient.createCollection(databaseLink, collectionDefinition, options);
%     documentCollection = collectionResponse.getResource();
%     collectionLink = documentCollection.getSelfLink();
% 
%     % create a document
%     documentContents = ['{ '...
%     '"name" : "Joe Blog", '...
%     '"country" : "USA", '...
%     '"income" : 70000'...
%     '}'];
%     documentDefinition = azure.documentdb.Document(documentContents);
%     disableAutomaticIdGeneration = false;
%     documentResponse = docClient.createDocument(collectionLink, documentDefinition, options, disableAutomaticIdGeneration);
%  
%     % Create the JavaScript code the UDF runs, could also be read from a file
%     jsCode = ['function tax(income) { '...
%                 'if(income == undefined) '...
%                 '  throw ''no input''; '...
%                 'if (income < 1000) '...
%                 '  return income * 0.1; ' ...
%                 'else if (income < 10000) '...
%                 '  return income * 0.2; '...
%                 'else '...
%                 '  return income * 0.4; '...
%              '}'];
% 
%     % create a collectionLink and then the UDF
%     containerLink = ['/dbs/',databaseId,'/colls/','Incomes'];
%     myUDF = azure.documentdb.UserDefinedFunction();
%     myUDF.setId('udfTax');
%     myUDF.setBody(jsCode);
%     createdUDF = docClient.createUserDefinedFunction(collectionLink, myUDF, options);
% 
%     % query the UDF
%     feedOptions = azure.documentdb.FeedOptions();
%     feedResponse = docClient.queryUserDefinedFunctions(collectionLink, 'SELECT * from r', feedOptions);
%     responseCellArray = feedResponse.getQueryCellArray();
% 
%     % read the udf
%     udfLink = [containerLink, '/', 'udfs/',myUDF.getId()];
%     readResponse = docClient.readUserDefinedFunction(udfLink, options);
%     readResult = readResponse.getResource();
% 
%     % read more than one udf if present
%     feedResponse = docClient.readUserDefinedFunctions(collectionLink, feedOptions);
%     responseCellArray = feedResponse.getQueryCellArray();
%     testCase.verifyEqual(char(responseCellArray{1}.getId()), myUDF.getId());
% 
%     % invoke the UDF
%     feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * FROM Incomes t WHERE udf.udfTax(t.income) > 20000', feedOptions);
%     responseCellArray = feedResponse.getQueryCellArray();
% 
%     % cleanup, delete the collection & database
%     docClient.deleteCollection(collectionLink, options);
%     docClient.deleteDatabase(databaseLink, options);
%     docClient.close;
%
%
% Constructor options:
%     azure.documentdb.UserDefinedFunction('myudfname');
%      or
%     azure.documentdb.UserDefinedFunction();
%      or
%     azure.documentdb.UserDefinedFunction(myJavaUdfObject)

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = UserDefinedFunction(varargin)

        % Create a logger object
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.UserDefinedFunction')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                obj.Handle = com.microsoft.azure.documentdb.UserDefinedFunction(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.UserDefinedFunction();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end
end
