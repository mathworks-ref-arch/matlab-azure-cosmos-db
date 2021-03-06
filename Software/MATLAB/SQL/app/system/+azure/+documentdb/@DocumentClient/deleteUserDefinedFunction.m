function result = deleteUserDefinedFunction(obj, userDefinedFunctionLink, options)
% DELETEUSERDEFINEDFUNCTION Deletes a User Defined Function
% Returns a ResourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(userDefinedFunctionLink)
    write(logObj,'error','Expected userDefinedFunctionLink of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.deleteUserDefinedFunction(userDefinedFunctionLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);


end %function
