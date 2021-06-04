function tf = allItemsAvailable(obj)
%ALLITEMSAVAILABLE Determines if all items have been returned to the client
%
% Returns true or false depending if the result item has been returned or
% not at the current time
%
% Example:
%
%   %Initialize a client
%   gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
%
%   %Create an "Add people as vetices" query and submit synchronously by using ```submit()```
% 
%   queries  = {"g.addV('person').property('id', 'thomas').property('firstName', 'Thomas').property('age', 44).property('pk', 'pk')",...
%     "g.addV('person').property('id', 'mary').property('firstName', 'Mary').property('lastName', 'Andersen').property('age', 39).property('pk', 'pk')",...
%     "g.addV('person').property('id', 'ben').property('firstName', 'Ben').property('lastName', 'Miller').property('age', 55).property('pk', 'pk')",...
%     "g.addV('person').property('id', 'robin').property('firstName', 'Robin').property('lastName', 'Wakefield').property('age', 22).property('pk', 'pk')"};
% 
%   % Get resultset
% 
%   resultset = gClient.submit(queries)
% 
%   resultset = 
% 
%       ResultSet with properties:
% 
%        Handle: {4x1 cell}
% 
%   % Check if results are ready to be read
%   tf = resultset.allItemsAvailable
% 
%   tf =
% 
%    1x4 cell array
% 
%        {[1]}    {[1]}    {[1]}    {[1]}
%

% (Copyright 2020, The MathWorks, Inc.)

% Copyright 2020 The MathWorks, Inc.

% Get Handle object ResultSet
resultsetJ = obj.Handle;

% Possible cellarray of resultsets for multple queries
n = numel(resultsetJ);

% Iterate over resultsets to find out completion
for i =1:n
    r = resultsetJ{n};
    tf{i} = r.allItemsAvailable;
end

end

