function result = deleteStoredProcedure(obj, storedProcedureLink, options)
% DELETESTOREDPROCEDURE Deletes a stored procedure
% Returns a ResourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(storedProcedureLink)
    write(logObj,'error','Expected storedProcedureLink of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.deleteStoredProcedure(storedProcedureLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);


end %function
