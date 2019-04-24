classdef Trigger < azure.object
% TRIGGER Represents a trigger in Cosmos DB
% Cosmos DB supports pre and post triggers defined in JavaScript to be executed
% on creates, updates and deletes.
%
% Example:
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
%
% Constructor options:
%    azure.documentdb.Trigger('mytriggername');
%    or
%    azure.documentdb.Trigger();
%    or
%    azure.documentdb.Trigger(myJavaTriggerObject)

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = Trigger(varargin)

        % Create a logger object
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.Trigger')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                obj.Handle = com.microsoft.azure.documentdb.Trigger(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.Trigger();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end
end
