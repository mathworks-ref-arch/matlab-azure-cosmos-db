function setProxy(obj, varargin)
% SETPROXY Sets a proxy which will be used when making a request
% If setProxy is called with no arguments it will will use the MATLAB
% proxy preference settings or if not set and on Windows the systems preferences
% will be used. A specific value can also be used.
%
% Examples:
%    Set the proxy to that set in the MATLAB preferences panel
%    if preferences are not set then use system preferences (Windows only):
%        cp = azure.documentdb.ConnectionPolicy();
%        cp.setProxy();
%
%    Set the proxy to a specific value:
%        cp.setProxy('http://myproxy.mycompany.com:8080');

% Copyright 2019 The MathWorks, Inc.

logObj = Logger.getLogger();

if isempty(varargin)
    % Read the host values from the MATLAB preferences using
    % getProxySettings in matlab.internal.webservices.HTTPConnector
    % approach
    % Get the proxy information using the MATLAB proxy API.
    % Ensure the Java proxy settings are set.
    com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings;

    % Obtain the proxy information for a given URL. Proxy settings can be
    % specific to URLs but this is unlikely
    url = java.net.URL('http://www.mathworks.com');
    % This function goes to MATLAB's preference panel or (if not set and on
    % Windows) the system preferences.
    javaProxy = com.mathworks.webproxy.WebproxyFactory.findProxyForURL(url);

    if ~isempty(javaProxy)
        address = javaProxy.address;
        if isa(address,'java.net.InetSocketAddress') && ...
                javaProxy.type == javaMethod('valueOf','java.net.Proxy$Type','HTTP')
            hostJ = shaded.org.apache.http.HttpHost(address);
            write(logObj,'verbose',['Setting proxy to: ',char(hostJ.toURI)]);
            obj.Handle.setProxy(hostJ);
        else
            write(logObj,'error','Invalid proxy');
        end
    else
        % do nothing as no proxy is set
        write(logObj,'verbose','MATLAB proxy preference not set');
    end
elseif (length(varargin) == 1) && ischar(varargin{1})
    % In this branch handle a proxy hostname and port that is passed as a char
    % use matlab.net.URI to parse the string
    hostURI = matlab.net.URI(varargin{1});
    hostJ = shaded.org.apache.http.HttpHost(hostURI.Host, hostURI.Port, hostURI.Scheme);
    write(logObj,'verbose',['Setting proxy to: ',char(hostJ.toURI)]);
    obj.Handle.setProxy(hostJ);
else
    write(logObj,'error','Invalid arguments');
end

end
