function result = getInt(obj, property)
% GETINT Gets an integer value for a given property
% Returns an int32
%
% Example:
%    feedResponse = docClient.queryDocuments(collectionLink, 'SELECT * from r', options);
%    responseCellArray = feedResponse.getQueryCellArray();
%    for n = 1:length(responseCellArray)
%       disp(['count is ',num2str(responseCellArray{n}.getInt('count'))]);
%    end

% Copyright 2019 The MathWorks, Inc.

if ~ischar(property)
    logObj = Logger.getLogger();
    write(logObj,'error','property argument not of type character vector');
end

result = int32(obj.Handle.getInt(property).intValue);

end
