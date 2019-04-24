function result = replaceOffer(obj, offer)
% REPLACEOFFER Replaces an offer
% Returns a ReourceResponse.

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~isa(offer, 'azure.documentdb.Offer')
    write(logObj,'error','offer argument not of type azure.documentdb.Offer');
end

resultJ = obj.Handle.replaceOffer(offer.Handle);
result = azure.documentdb.ResourceResponse(resultJ);

end %function
