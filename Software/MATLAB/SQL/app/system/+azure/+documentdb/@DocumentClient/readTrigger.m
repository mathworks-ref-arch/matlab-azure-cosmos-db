function result = readTrigger(obj, triggerLink, options)
% READTRIGGER Reads a trigger by the trigger link.
% Returns a ReourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(triggerLink)
    write(logObj,'error','triggerLink argument not of type character vector');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.readTrigger(triggerLink, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
