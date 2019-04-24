function result = getBody(obj)
% GETBODY Get the body of the UDF
% Returns a character vector.

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.getBody());

end
