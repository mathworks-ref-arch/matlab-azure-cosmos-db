function result = deleteTrigger(obj, triggerLink, options)
% DELETETRIGGER Deletes a trigger by the trigger link
% Returns a ResourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(triggerLink)
    write(logObj,'error','Expected triggerLink of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.deleteTrigger(triggerLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
