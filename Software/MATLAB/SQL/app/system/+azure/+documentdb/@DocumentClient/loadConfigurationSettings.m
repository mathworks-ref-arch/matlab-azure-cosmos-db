function loadConfigurationSettings(obj, varargin)
% LOADCONFIGURATIONSETTINGS read DocumentClient configuration file
% By default the configuration file is called: documentdb.json
% or the name can be specified as an argument. If account configuration settings
% are not provided the locally hosted development account will be used.

% Copyright 2019 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if nargin > 2
    write(logObj,'error','Too many arguments');
end

if nargin == 2
    if ~ischar(varargin{1})
        write(logObj,'error','Expected argument of type character vector');
    end
end

if isempty(varargin)
    configFile = which('documentdb.json');
else
    configFile = varargin{1};
end

if which(configFile)
    config = jsondecode(fileread(which(configFile)));
    obj.serviceEndpoint = config.serviceEndpoint;
    obj.masterKey = config.masterKey;
else
    write(logObj,'error',['Configuration file not found: ',which(configFile)]);
end

end
