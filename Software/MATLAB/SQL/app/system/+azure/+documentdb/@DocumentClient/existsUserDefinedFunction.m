function tf = existsUserDefinedFunction(obj, udfLink, options)
% EXISTSUSERDEFINEDFUNCTION Tests if a UDF exists or not
% Returns true if the database exists otherwise false. Existence is determined
% by calling readUserDefinedFunction() if the read fails with a "Resource Not Found"
% exception false is returned otherwise true is returned. Thus true may be
% returned in the case of other exceptions even if the database does not exist.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(udfLink)
    write(logObj,'error','udfLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

try
    obj.Handle.readUserDefinedFunction(udfLink, options.Handle);
    tf = true;
catch ex
    % if the exception is database doesn't exist don't throw it and return false
    if contains(ex.message, 'com.microsoft.azure.documentdb.DocumentClientException: Message: {"Errors":["Resource Not Found"]}')
        tf = false;
    else
        % It may exists and the exception is something other than "Resource
        % Not Found" conservatively return true.
        tf = true;
    end
end
