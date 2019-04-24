function result = createDatabase(obj, database, options)
% CREATEDATABASE Creates a database
% The database name or Id must have been set prior to creating the Database in
% Cosmos DB, either at declaration or with a subsequent setId() call.
% Returns a ResourceResponse.
%
% Example:
%   options = azure.documentdb.RequestOptions();
%   database = azure.documentdb.Database('mydbname');
%   docClient.createDatabase(database, options);
%   % or
%   options = azure.documentdb.RequestOptions();
%   database = azure.documentdb.Database();
%   database.setId('mydbname');
%   docClient.createDatabase(database, options);

% Copyright 2019 The MathWorks, Inc.

import com.microsoft.azure.documentdb.*;

% Create a logger object
logObj = Logger.getLogger();

if ~isa(options, 'azure.documentdb.RequestOptions')
    write(logObj,'error','options argument not of type azure.documentdb.RequestOptions');
end

if isa(database,'azure.documentdb.Database')
    if isempty(database.getId)
        % handle not initialized with name / ID
        write(logObj,'error','Database name has not been set');
    else
        resultJ = obj.Handle.createDatabase(database.Handle, options.Handle);
        result = azure.documentdb.ResourceResponse(resultJ);
    end
else
    write(logObj,'error','Expecting argument of type azure.documentdb.Database');
end

end
