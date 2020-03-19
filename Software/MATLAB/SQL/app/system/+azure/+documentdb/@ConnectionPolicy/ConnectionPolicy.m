classdef ConnectionPolicy < azure.object
% CONNECTIONPOLICY Represents Connection policy associated with a DocumentClient
%
% Example:
%    myConnectionPolicy = azure.documentdb.ConnectionPolicy();
%    myConnectionPolicy.setProxy('http://myproxy.mycompany.com:8080');
%    docClient = azure.documentdb.DocumentClient('connectionPolicy', myConnectionPolicy)

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = ConnectionPolicy(varargin)
        logObj = Logger.getLogger();

        if nargin == 1
            if isa(varargin{1},'com.microsoft.azure.documentdb.ConnectionPolicy')
                obj.Handle = varargin{1};
            else
                argType = class(varargin{1});
                write(logObj,'error',['Unexpected argument of type: ', argType]);
            end
        elseif nargin == 0
            connectionPolicyJ = com.microsoft.azure.documentdb.ConnectionPolicy();
            obj.Handle = connectionPolicyJ.GetDefault();
        else
            write(logObj,'error','Invalid number of arguments');
        end
    end %function
end %methods
end %class
