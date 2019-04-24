function setTriggerOperation(obj, operation)
% SETTRIGGEROPERATION Set the operation type of the trigger

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~isa(operation, 'azure.documentdb.TriggerOperation')
    write(logObj,'error','Expected operation argument to be of type azure.documentdb.TriggerOperation');
end

switch operation
case azure.documentdb.TriggerOperation.All
    opJ = com.microsoft.azure.documentdb.TriggerOperation.All;
case azure.documentdb.TriggerOperation.Create
    opJ = com.microsoft.azure.documentdb.TriggerOperation.Create;
case azure.documentdb.TriggerOperation.Delete
    opJ = com.microsoft.azure.documentdb.TriggerOperation.Delete;
case azure.documentdb.TriggerOperation.Replace
    opJ = com.microsoft.azure.documentdb.TriggerOperation.Replace;
case azure.documentdb.TriggerOperation.Update
    opJ = com.microsoft.azure.documentdb.TriggerOperation.Update;
otherwise
    write(logObj,'error','Invalid TriggerOperation type');
end

obj.Handle.setTriggerOperation(opJ);

end
