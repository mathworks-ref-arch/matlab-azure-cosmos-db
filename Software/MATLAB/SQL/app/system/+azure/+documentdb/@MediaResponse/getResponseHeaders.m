function containerMapResult = getResponseHeaders(obj)
% GETRESPONSEHEADERS Gets the headers associated with the response
% Returns a containers.Map object. If there are no headers an empty
% containers.Map is returned.

% Copyright 2019 The MathWorks, Inc.

% return the result as a Java Map
mapJ = obj.Handle.getResponseHeaders();

% the following conversion process is not optimal for performance or scale
% but is straightforward and sufficient for object metadata

% return and entrySet to get an iterator
entrySetJ = mapJ.entrySet();
% get the iterator
iteratorJ = entrySetJ.iterator();

% declare empty cell arrays for values and keys in case there are no entries
keys = {};
values = {};

while iteratorJ.hasNext()
    % pick metadata from the entry set one at a time
    entryJ = iteratorJ.next();
    % get the key and the value
    key = entryJ.getKey();
    value = entryJ.getValue();
    % build the cell arrays of keys and values
    keys{end+1} = key; %#ok<AGROW>
    values{end+1} = value; %#ok<AGROW>
end

% if the cell arrays are still empty then create an empty containers.Map and
% return that else build it from the arrays of values and keys
if isempty(keys)
    containerMapResult = containers.Map('KeyType','char','ValueType','char');
else
    containerMapResult = containers.Map(keys,values);
end

end
