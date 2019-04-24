function result = readMedia(obj, mediaLink)
% READMEDIA Reads media by the media link
% Returns a MediaResponse.

% Copyright 2019 The MathWorks, Inc.


if ~ischar(mediaLink)
    logObj = Logger.getLogger();
    write(logObj,'error','mediaLink argument not of type character vector');
end

resultJ = obj.Handle.readMedia(mediaLink);
result = azure.documentdb.MediaResponse(resultJ);

end %function
