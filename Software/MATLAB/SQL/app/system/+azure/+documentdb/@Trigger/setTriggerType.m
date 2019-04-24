function setTriggerType(obj, type)
% SETTRIGGERTYPE Set the type of the trigger

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~isa(type, 'azure.documentdb.TriggerType')
    write(logObj,'error','Expected type argument to be of type azure.documentdb.TriggerType');
end

switch type
case azure.documentdb.TriggerType.Pre
    typeJ = com.microsoft.azure.documentdb.TriggerType.Pre;
case azure.documentdb.TriggerType.Post
    typeJ = com.microsoft.azure.documentdb.TriggerType.Post;
otherwise
    write(logObj,'error','Invalid TriggerType type');
end

obj.Handle.setTriggerType(typeJ);

end
