function cluster = getCluster(gremlinClient)
% GETCLUSTER Returns string containing details of the Cluster Object for this client
%
% Example:
%
%   % Initialize client
%   gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
%
%   % Find cluster details
%   cluster = gremlinClient.getCluster();
%

%(Copyright 2020, The MathWorks, Inc.)

% Setup Logger
logObj = Logger.getLogger();

% Get gremlin client Handle
client = gremlinClient.Handle;

% Get Cluster
clusterJ = client.getCluster;

% Return string
cluster = clusterJ.toString;
end

