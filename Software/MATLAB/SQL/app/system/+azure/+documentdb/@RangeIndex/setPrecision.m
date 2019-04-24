function setPrecision(obj, precision)
% SETPRECISION Sets precision, input converted to an int32

% Copyright 2019 The MathWorks, Inc.

if ~(isnumeric(precision) && isscalar(precision))
    logObj = Logger.getLogger();
    write(logObj,'error','precision argument not of type numeric scalar');
else
    obj.Handle.setPrecision(int32(precision));
end

end
