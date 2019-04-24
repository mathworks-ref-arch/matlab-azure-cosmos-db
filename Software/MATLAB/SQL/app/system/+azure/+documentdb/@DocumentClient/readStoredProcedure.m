function result = readStoredProcedure(obj, storedProcedureLink, options)
% READSTOREDPROCEDURE Read a stored procedure by the stored procedure link
% Returns a ResourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(storedProcedureLink)
    write(logObj,'error','storedProcedureLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.readStoredProcedure(storedProcedureLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
