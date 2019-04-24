function result = getTriggerOperation(obj)
% GETTRIGGEROPERATION Get the operation type of the trigger
% Returns a TriggerOperation object.

% Copyright 2019 The MathWorks, Inc.

enumJ = obj.Handle.getTriggerOperation();

switch enumJ
case com.microsoft.azure.documentdb.TriggerOperation.All
    result = azure.documentdb.TriggerOperation.All;
case com.microsoft.azure.documentdb.TriggerOperation.Create
    result = azure.documentdb.TriggerOperation.Create;
case com.microsoft.azure.documentdb.TriggerOperation.Delete
    result = azure.documentdb.TriggerOperation.Delete;
case com.microsoft.azure.documentdb.TriggerOperation.Replace
    result = azure.documentdb.TriggerOperation.Replace;
case com.microsoft.azure.documentdb.TriggerOperation.Update
    result = azure.documentdb.TriggerOperation.Update;
otherwise
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid TriggerOperation type');
end

end
