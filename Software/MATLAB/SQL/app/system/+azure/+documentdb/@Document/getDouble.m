function result = getDouble(obj, property)
% GETDOUBLE Gets a double value for a given property
%
% Example:
%   feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
%   responseCellArray = feedResponse.getQueryCellArray();
%   for n = 1:length(responseCellArray)
%       disp(['id is ',responseCellArray{n}.getId()]);
%       disp(['popularity is ', num2str(responseCellArray{n}.getDouble('popularity'))]);
%   end

% Copyright 2019 The MathWorks, Inc.

if ~ischar(property)
    logObj = Logger.getLogger();
    write(logObj,'error','property argument not of type character vector');
end

result = obj.Handle.getDouble(property).doubleValue;

end
