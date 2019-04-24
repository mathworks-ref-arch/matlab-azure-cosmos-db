function result = readUserDefinedFunction(obj, udfLink, options)
% READUSERDEFINEDFUNCTION Read a user defined function
% Returns a ReourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(udfLink)
    write(logObj,'error','udfLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.readUserDefinedFunction(udfLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
