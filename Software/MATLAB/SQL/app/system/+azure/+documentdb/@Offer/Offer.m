classdef Offer < azure.object
% OFFER Initialize an offer object
%
% Example:
%    queryStr = ['SELECT * FROM c where c.offerResourceId = ''', documentCollection.getResourceId(),''''];
%    feedOptions = azure.documentdb.FeedOptions();
%    offersFeedResponse = docClient.queryOffers(queryStr, feedOptions);
%    offerIteratorJ = offersFeedResponse.Handle.getQueryIterator();
%    offer = azure.documentdb.Offer(offerIteratorJ.next());
%    % returns a Java JSON object
%    contentJSON = offer.getContent();

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = Offer(varargin)

        % Create a logger object
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.Offer')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                obj.Handle = com.microsoft.azure.documentdb.Offer(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.Offer();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end
end
