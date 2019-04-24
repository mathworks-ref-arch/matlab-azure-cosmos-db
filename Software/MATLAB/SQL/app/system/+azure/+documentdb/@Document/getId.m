function result = getId(obj)
% GETID Gets the name of the resource
% Returns the document Id as a character vector
%
% Example:
%   feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
%   responseCellArray = feedResponse.getQueryCellArray();
%   for n = 1:length(responseCellArray)
%       disp(['id is ',responseCellArray{n}.getId()]);
%   end

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getId());

end
