classdef MediaResponse < azure.object
% MEDIARESPONSE Response associated with retrieving attachment content

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = MediaResponse(varargin)
        logObj = Logger.getLogger();

        if nargin == 0
            % do nothing, don't set handle
        elseif nargin == 1
            if ~isa(varargin{1}, 'com.microsoft.azure.documentdb.MediaResponse')
                write(logObj,'error','argument not of type com.microsoft.azure.documentdb.MediaResponse');
            end
            obj.Handle = varargin{1};
        else
            write(logObj,'error','Invalid number of arguments');
        end

    end %function
end %methods
end %class
