classdef FeedOptions < azure.object
% FEEDOPTIONS Options associated with feed methods in Cosmos DB
%
% Examples:
%    azure.documentdb.FeedOptions();
%    % or using a com.microsoft.azure.documentdb.FeedOptions object
%    azure.documentdb.FeedOptions(myFeedOptionsObject)

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = FeedOptions(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.FeedOptions')
                obj.Handle = varargin{1};
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.FeedOptions();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end %function
end %methods
end %class
