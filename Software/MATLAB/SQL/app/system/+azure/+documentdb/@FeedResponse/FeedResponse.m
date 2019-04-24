classdef FeedResponse < azure.object
% FEEDRESPONSE Used by feed methods (enumeration operations) in Cosmos DB
% DocumentClient methods that return multiple response will in general return a
% FeedResponse object from which the resources can be retrieved.

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = FeedResponse(varargin)
        logObj = Logger.getLogger();

        if nargin == 0
            % do nothing, don't set handle
        elseif nargin == 1
            if ~isa(varargin{1}, 'com.microsoft.azure.documentdb.FeedResponse')
                write(logObj,'error','argument not of type com.microsoft.azure.documentdb.FeedResponse');
            end
            obj.Handle = varargin{1};
        else
            write(logObj,'error','Invalid number of arguments');
        end

    end %function
end %methods
end %class
