function result = executeStoredProcedure(obj, storedProcedureLink, requestOptions, procedureParameters)
% GETSTOREDPROCEDURES Executes a stored procedure using the procedure's link
% A azure.documentdb.StoredProcedureResponse object is returned.
% If no procedure parameters are required an empty cell array {} can be
% passed.
% Returns a StoredProcedureResponse.
%
% Example:
%    storedProcedure =  azure.documentdb.StoredProcedure(storedProcedureStr);
%    docClient.createStoredProcedure(collectionLink, storedProcedure, options);
%    storedProcLink = ['/dbs/',databaseId,'/colls/', collectionId,'/sprocs/','storedProcedureSample'];
%    requestOptions = azure.documentdb.RequestOptions();
%    requestOptions.setScriptLoggingEnabled(true);
%    requestOptions.setPartitionKey(azure.documentdb.PartitionKey('myKey'));
%    storedProcedureResponse = docClient.executeStoredProcedure(storedProcLink, requestOptions, {});

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(storedProcedureLink)
    write(logObj,'error','storedProcedureLink argument not of type character vector');
end

if ~isa(requestOptions,'azure.documentdb.RequestOptions')
    write(logObj,'error','requestOptions argument not of type azure.documentdb.RequestOptions');
end

if ~iscell(procedureParameters)
    write(logObj,'error','storedProcedureLink argument not of type cell array');
end

if ~isempty(procedureParameters)
    if ~isvector(procedureParameters)
        write(logObj,'error','procedureParams must be a vector');
    end
end

% convert the cell array to an array list
procedureParamsJArrayList = java.util.ArrayList();
for n=1:numel(procedureParameters)
    % rely on MATLAB to marshal procedureParams{n} to Java
    procedureParamsJArrayList.add(procedureParameters{n});
end
% convert the java.util.ArrayList to java.lang.Object[]
procedureParamsJ = procedureParamsJArrayList.toArray();

% returns a com.microsoft.azure.documentdb.StoredProcedureResponse
resultJ = obj.Handle.executeStoredProcedure(storedProcedureLink, requestOptions.Handle, procedureParamsJ);
result = azure.documentdb.StoredProcedureResponse(resultJ);

end %function
