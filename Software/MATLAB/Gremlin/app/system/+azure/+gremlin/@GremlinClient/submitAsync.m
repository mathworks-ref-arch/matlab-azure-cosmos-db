function response = submitAsync(gremlinClient,queries)
% SUBMITASYNC submits a query to Gremlin DB and returns a Graph Query Response of type CompletableFuture.
% 
% This is an asynchronous version of gremlinclient.submit("queries"),
% where the returned future will complete when the write of the request completes.
%
% queries is a set of input queries ranging from 1 to any number
%
% Input argument 'queries' is of the type cell array containing comma
% seperated query strings e.g. queries = {"query1", "query2",...,"queryn"};
%
% Example:
%
%   % Initialize client
%   gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
%
%   % Write a cell array containing single or a set of multiple queries seperated by comma
%   queries = {"g.V().drop()",
%              "g.addV('person').property('id','thomas').property('firstName', 'Thomas').property('age',44).property('pk', 'pk')"};
%
%   % Submit queries
%   response = gremlinClient.submitAsync(queries)
%

%(Copyright 2020, The MathWorks, Inc.)

% Setup Logger
logObj = Logger.getLogger();

% Get gremlin client Handle
client = gremlinClient.Handle;

% Check if input argument is empty
if isempty(queries)
    write(logObj,'error','No input found. To learn more see help azure.gremlin.GremlinClient.submit');
else
    % Check if queries is a cell array containing queries
    if ~isequal('cell',class(queries))
        write(logObj,'error',['Expecting input queries to be a cell array with query strings seperated by comma. Found ' class(queries) ' instead']);
    else
        % Creating container cell array to store results for all queries
        responseJ=cell(numel(queries),1);
        
        % Iterating over queries
        for i = 1:numel(queries)
            try
                % Asynchronously submit a query at a time and recieve
                % response of type CompletableFuture<ResultSet>
                responseJ{i,1} = client.submitAsync(queries{i});
            catch exception
                write(logObj,'error',exception.message);
            end
        end
        % Wrapping java class
        % 'java.util.concurrent.CompletableFuture<T>' to MATLAB class
        % +azure/+gremlin/@CompletableFuture<ResultSet>
        response = azure.gremlin.CompletableFuture(responseJ);
    end
end
end

