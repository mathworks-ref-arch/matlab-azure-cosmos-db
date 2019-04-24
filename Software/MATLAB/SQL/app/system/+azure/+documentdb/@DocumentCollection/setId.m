function setId(obj, collectionName)
% SETID Sets the name of the resource
%
% Example:
%    collection = azure.documentdb.DocumentCollection();
%    collection.setId('mycollection');

% Copyright 2019 The MathWorks, Inc.

if ~ischar(collectionName)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected collectionName as a character vector');
end

obj.Handle.setId(collectionName);

end
