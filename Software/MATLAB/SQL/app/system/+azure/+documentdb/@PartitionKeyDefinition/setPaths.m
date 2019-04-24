function setPaths(obj, paths)
% SETPATHS Sets paths in a partition key definition
% paths are passed in as a MATLAB string array
%
% Example:
%    partitionKeyPath = ['/' , partitionKeyFieldName];
%    paths = string(partitionKeyPath);
%    partitionKeyDefinition.setPaths(paths);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~isstring(paths)
    write(logObj,'error','paths argument not of type string or string array');
end

pathListJ = java.util.ArrayList();
for n = 1:numel(paths)
    pathListJ.add(paths(n));
end

obj.Handle.setPaths(pathListJ);

end
