function result = getResponseAsString(obj)
% GETRESPONSEASSTRING Gets response of a stored procedure as a character vector

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getResponseAsString());

end
