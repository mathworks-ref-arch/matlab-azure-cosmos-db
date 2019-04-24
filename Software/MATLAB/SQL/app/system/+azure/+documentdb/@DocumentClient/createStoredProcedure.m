function result = createStoredProcedure(obj, collectionLink, storedProcedure, options)
% CREATESTOREDPROCEDURE Creates a stored procedure
% Returns a ResourceResponse.
%
% Examples:
%     % Execute Stored Procedure with Arguments
%     storedProcedureStr = ['{' ,...
%        '  "id" : "multiplySample",' ,...
%        '  "body" : ' ,...
%        '    "function (value, num) {' ,...
%        '       getContext().getResponse().setBody(\"2*\" + value + \" is \" + num * 2);' ,...
%        '     }"' ,...
%        '}'];
%     storedProcedure =  azure.documentdb.StoredProcedure(storedProcedureStr);
%     docClient.createStoredProcedure(collectionLink, storedProcedure, options);
%
%     Note the id and body can be struct members and JSON encoded by MATLAB
%     alternatively. This is less error prone regarding escaping special
%     characters etc.
%
%     storedProcedureStruct.id = 'storedProcedureSample'
%     storedProcedureStruct.body = ['function() {' ,...
%        '        var mytext = "x";' ,...
%        '        var myval = 1;' ,...
%        '        try {' ,...
%        '            console.log("The value of %s is %s.", mytext, myval);' ,...
%        '            getContext().getResponse().setBody("Success!");' ,...
%        '        }' ,...
%        '        catch(err) {' ,...
%        '            getContext().getResponse().setBody("inline err: [" + err.number + "] " + err);' ,...
%        '        }' ,...
%        '     }']
%     storedProcedureStr = jsonencode(storedProcedureStruct)

% Copyright 2019 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','Expected collectionLink of type character vector');
end

if ~isa(storedProcedure, 'azure.documentdb.StoredProcedure')
    write(logObj,'error','Expected storedProcedure argument to be of type azure.documentdb.storedProcedure');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type RequestOptions');
end

resultJ = obj.Handle.createStoredProcedure(collectionLink, storedProcedure.Handle, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end % createStoredProcedure
