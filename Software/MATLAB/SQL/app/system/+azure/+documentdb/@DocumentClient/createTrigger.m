function result = createTrigger(obj, collectionLink, trigger, options)
% CREATEDOCUMENT Creates a trigger
% Returns a ResourceResponse.
%
% Example:
%    % create trigger
%    triggerId = 'mytriggerexample';
%    trigger = azure.documentdb.Trigger();
%    trigger.setId(triggerId);
%    triggerBody = ['function testTrigger() {',...
%        ' var context = getContext();' ,...
%        ' var request = context.getRequest();' ,...
%        ' var myDocument = request.getBody();' ,...
%        ' myDocument["myTest"] = "Created by createTrigger";' ,...
%        ' request.setBody(myDocument);' ,...
%    '}'];
%    trigger.setBody(triggerBody);
%    trigger.setTriggerType(azure.documentdb.TriggerType.Pre);
%    trigger.setTriggerOperation(azure.documentdb.TriggerOperation.Delete);
%    docClient.createTrigger(collectionLink, trigger, options);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(collectionLink)
    write(logObj,'error','collectionLink argument not of type character vector');
end

if ~isa(trigger, 'azure.documentdb.Trigger')
    write(logObj,'error','Expected trigger argument to be of type azure.documentdb.Trigger');
end

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

resultJ = obj.Handle.createTrigger(collectionLink, trigger.Handle, options.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
