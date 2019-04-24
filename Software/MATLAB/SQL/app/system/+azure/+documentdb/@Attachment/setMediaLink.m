function setMediaLink(obj, mediaLink)
% SETMEDIALINK Sets the media link associated with the attachment content
%
% Example:
%   myAttachment.setMediaLink('www.mathworks.com');

% Copyright 2019 The MathWorks, Inc.

if ~ischar(mediaLink)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','Expected mediaLink as a character vector');
end

obj.Handle.setMediaLink(mediaLink);

end
