function setEnableCrossPartitionQuery(obj, enableCrossPartitionQuery)
% SETENABLECROSSPATITIONQUERY Allows queries across all collection partitions

% Copyright 2019 The MathWorks, Inc.

if ~islogical(enableCrossPartitionQuery)
    logObj = Logger.getLogger();
    write(logObj,'error','enableCrossPartitionQuery argument not of type logical');
end

% convert to Boolean rather than boolean MATLAB will pass based on a
% logical
BooleanArg = java.lang.Boolean(enableCrossPartitionQuery);
obj.Handle.setEnableCrossPartitionQuery(BooleanArg);

end
