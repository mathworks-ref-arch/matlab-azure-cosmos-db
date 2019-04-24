function result = getTriggerType(obj)
% GETTRIGGERTYPE Get the type of the trigger
% Returns a TriggerType object.

% Copyright 2019 The MathWorks, Inc.

enumJ = obj.Handle.getTriggerType();

switch enumJ
case com.microsoft.azure.documentdb.TriggerType.Pre
    result = azure.documentdb.TriggerType.Pre;
case com.microsoft.azure.documentdb.TriggerType.Post
    result = azure.documentdb.TriggerType.Post;
otherwise
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid TriggerType type');
end

end
