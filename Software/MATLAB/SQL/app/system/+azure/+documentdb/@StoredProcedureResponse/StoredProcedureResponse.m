classdef StoredProcedureResponse < azure.object
% STOREDPROCEDURERESPONSE Represents response from a stored procedure
% This object wraps the response body and headers.

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = StoredProcedureResponse(response)
        logObj = Logger.getLogger();

        if nargin == 1
            if ~isa(response, 'com.microsoft.azure.documentdb.StoredProcedureResponse')
                write(logObj,'error','argument not of type com.microsoft.azure.documentdb.StoredProcedureResponse');
            end
            obj.Handle = response;
        else
            write(logObj,'error','Invalid number of arguments');
        end

    end %function
end %methods
end %class
