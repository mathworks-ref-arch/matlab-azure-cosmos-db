function result = getBoolean(obj, property)
% GETBOOLEAN Gets an Boolean value for a given property
% Returns an logical
%

% Copyright 2019 The MathWorks, Inc.

if ~ischar(property)
    logObj = Logger.getLogger();
    write(logObj,'error','property argument not of type character vector');
end

resultJ = obj.Handle.getBoolean(property);
result = resultJ.booleanValue();

end
