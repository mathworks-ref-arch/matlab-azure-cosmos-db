function result = getString(obj, property)
% GETSTRING Gets a string value for a given property in character vector form
%
% Example:
%   feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
%   responseCellArray = feedResponse.getQueryCellArray();
%   for n = 1:length(responseCellArray)
%       disp(['city is ',responseCellArray{n}.getString('city')]);
%   end

% Copyright 2019 The MathWorks, Inc.

if ~ischar(property)
    logObj = Logger.getLogger();
    write(logObj,'error','property argument not of type character vector');
end

result = char(obj.Handle.getString(property));

end
