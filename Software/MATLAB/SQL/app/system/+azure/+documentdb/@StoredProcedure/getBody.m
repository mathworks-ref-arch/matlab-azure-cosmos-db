function result = getBody(obj)
% GETBODY Returns the the body of the stored procedure
% Returns a character vector.

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getBody());

end
