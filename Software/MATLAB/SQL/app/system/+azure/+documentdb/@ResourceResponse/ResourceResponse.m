classdef ResourceResponse < azure.object
% RESOURCERESPONSE Represents response to a request made from DocumentClient
% in Cosmos DB database service. It contains both the resource and the response
% headers.

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = ResourceResponse(varargin)
        logObj = Logger.getLogger();

        if nargin == 0
            % do nothing, don't set handle
        elseif nargin == 1
            if ~isa(varargin{1}, 'com.microsoft.azure.documentdb.ResourceResponse')
                write(logObj,'error','argument not of type com.microsoft.azure.documentdb.ResourceResponse');
            end
            obj.Handle = varargin{1};
        else
            write(logObj,'error','Invalid number of arguments');
        end

    end %function
end %methods
end %class
