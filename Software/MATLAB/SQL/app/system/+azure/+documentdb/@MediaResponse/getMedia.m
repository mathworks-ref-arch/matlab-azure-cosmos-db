function tf = getMedia(obj, outputFile)
% GETMEDIA Gets the attachment content stream and writes it to a file
% True is returned on successful completion

% Copyright 2019 The MathWorks, Inc.

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import org.apache.commons.io.IOUtils;

% default to returning false
tf = false; %#ok<NASGU>

% get the input stream for the SDK
inpStream = obj.Handle.getMedia();

% get an output stream based on the provided filename
outputStream = java.io.FileOutputStream(outputFile);
% Copy one stream to another and cleanup
IOUtils.copy(inpStream,outputStream);

% close streams and return true
outputStream.close();
inpStream.close();
tf = true;

end
