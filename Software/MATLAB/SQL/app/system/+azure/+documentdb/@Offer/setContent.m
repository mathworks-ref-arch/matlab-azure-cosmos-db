function setContent(obj, offerContent)
% SETCONTENT Sets the offer content that contains the details of the offer

% Copyright 2019 The MathWorks, Inc.

if ~isa(offerContent, 'org.json.JSONObject')
    logObj = Logger.getLogger();
    write(logObj,'error','offerContent argument not of type JSONObject');
end

obj.Handle.setContent(offerContent);

end
