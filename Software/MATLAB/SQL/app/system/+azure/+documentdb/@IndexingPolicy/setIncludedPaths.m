function setIncludedPaths(obj, includedPaths)
% SETINCLUDEDPATHS Sets Included paths for an indexingPolicy
%
% Example:
%    includedPaths = {includedPath};
%    indexingPolicy.setIncludedPaths(includedPaths);

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~iscell(includedPaths)
    write(logObj,'error','includedPaths argument not of type cell array');
end

if ~isvector(includedPaths)
    write(logObj,'error','includedPaths must be a vector');
end

for n=1:numel(includedPaths)
    if ~isa(includedPaths{n},'azure.documentdb.IncludedPath')
        argType = class(includedPaths{n});
        write(logObj,'error',['Unexpected argument of type: ',argType]');
    end
end

% build a Java ArrayList of their Handle objects
includedPathsJ = java.util.ArrayList();
for n=1:numel(includedPaths)
    includedPathsJ.add(includedPaths{n}.Handle);
end

obj.Handle.setIncludedPaths(includedPathsJ);

end
