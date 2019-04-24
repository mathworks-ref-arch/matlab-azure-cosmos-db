classdef MediaOptions < azure.object
% MEDIAOPTIONS Initialize a MediaOptions object
%
% Example:


% Copyright 2019 The MathWorks, Inc.

methods
    function obj = MediaOptions(varargin)

        % Create a logger object
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.MediaOptions')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1})
                obj.Handle = com.microsoft.azure.documentdb.MediaOptions(varargin{1});
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.documentdb.MediaOptions();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end
end
end
