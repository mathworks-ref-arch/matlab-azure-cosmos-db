function setOfferThroughput(obj, throughput)
% SETOFFERTHROUGHPUT Sets throughput in Request Units per second
% This can be used when creating a document collection.
%
% Example:
%    options = azure.documentdb.RequestOptions();
%    options.setOfferThroughput(400);
%    docClient.createCollection(databaseLink, myCollection, options);

% Copyright 2019 The MathWorks, Inc.

if ~(isnumeric(throughput) && isscalar(throughput))
    logObj = Logger.getLogger();
    write(logObj,'error','throughput argument not of type numeric scalar');
end

throughputIntJ = java.lang.Integer(int32(throughput));

obj.Handle.setOfferThroughput(throughputIntJ);

end
