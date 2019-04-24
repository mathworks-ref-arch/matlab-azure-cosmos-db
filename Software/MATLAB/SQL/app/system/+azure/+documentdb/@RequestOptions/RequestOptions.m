classdef RequestOptions < azure.object
% REQUESTOPTIONS Options for a request issued to the database service
%
% Example:
%    options = azure.documentdb.RequestOptions();
%    options.setOfferThroughput(400);
%    docClient.createCollection(databaseLink, myCollection, options);

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = RequestOptions()
        obj.Handle = com.microsoft.azure.documentdb.RequestOptions();
    end
end
end
