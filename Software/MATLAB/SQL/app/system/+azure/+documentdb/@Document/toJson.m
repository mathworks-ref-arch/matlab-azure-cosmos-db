function result = toJson(obj)
% TOJSON Converts to a JSON string in character vector form

% Copyright 2019 The MathWorks, Inc.

result = char(obj.Handle.toJson());

end
