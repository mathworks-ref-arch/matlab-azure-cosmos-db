function result = createUserDefinedFunction(obj, collectionLink, udf, options)
% CREATEUSERDEFINEDFUNCTION Creates a User Defined Function
% Returns a ResourceResponse.
%
% Examples:
% TODO

% Copyright 2019 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','Expected collectionLink of type character vector');
end

if ~isa(udf, 'azure.documentdb.UserDefinedFunction')
    write(logObj,'error','Expected udf argument to be of type azure.documentdb.UserDefinedFunction');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type RequestOptions');
end

resultJ = obj.Handle.createUserDefinedFunction(collectionLink, udf.Handle, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end % createUserDefinedFunction
