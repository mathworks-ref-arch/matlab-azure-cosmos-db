function results = get(obj)
% GET custom method to obtain query results from ResultSet by using
% iterator
% ResultDet.iterator() Returns a blocking iterator of the items streaming from the server to the client.
%
% Example:
%
%   % Initialize client
%   gremlinClient = azure.gremlin.GremlinClient('gremlindb.yml');
%
%   % Write a cell array containing single or a set of multiple queries seperated by comma
%   queries = {"g.V().drop()",
%              "g.addV('person').property('id','thomas').property('firstName', 'Thomas').property('age',44).property('pk', 'pk')"};
%
%   % Submit queries synchronously
%   resultSet = gremlinClient.submit(queries)
%
%   % Get results once queries are written
%   response = resultSet.get
%
% Reference: https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CompletableFuture.html#get--

% Copyright 2020 The MathWorks, Inc.

% Accessing ResultSet object from Handle
resultsetJ = obj.Handle;

% Creating an empty cell array to contain results and return at the end of
% execution
results = {};

% Creating a MATLAB variable response for unpacking process of the Resultset java object
response = resultsetJ;

% class(response) % Uncomment for verbosity during debugging

% Obtain size of the ResultSet object now contained within the variable
% response
numresp = numel(response);

% Testing for a non-empty response
if numresp > 0
    
  % Looping through contents of the response object
    for n = 1: numresp
        fprintf('Waiting for all results ...\n');
        while ~(response{n}.allItemsAvailable())
           % fprintf('. .')
        end
        % Create an iterator for the response object
        
        %% ToDo: Check class 
        % Error message for edge cases
        % Unit test for edge cases
        % Community graph databases for bash
        %%
        result = response{n}.iterator;
        % Test for possible iterations
        if ~(result.hasNext)
            % return empty struct within variable s, if no more iterations
            % possible
            s = struct;
        end
        % MATLAB variable cnt to track number of iterations and values
        % returned for every iteration
        % Intialized to 0 iterations
        cnt = 0;
        % Iterating over the iterator - MATLAB variable result is the
        % iterator here. constructed in line 47
        while result.hasNext
            
            % Access current iteration
            itr = result.next;
            
            % Increment tracking counter
            cnt = cnt + 1;
            
            % Access object in current iteration
            dataObject = itr.getObject;
            
            % Test for class of the object to identify unpacking rules
            % using the helper function 'value_unpack()'
            %
            % The parent object for all current test queries have been
            % either of type 'java.util.LinkedHashMap' or single entitites
            % of type 'double','single','char','string'
            %
            % The next conditional check is to identify the class of the
            % parent object only
            
            if  ~isequal(class(dataObject),'java.util.LinkedHashMap')
                % If the parent object is not a hashmap and is any of the
                % following datatypes such as 'string', 'char', 'double',
                % 'single' they are assigned as is to the return object 's'
                % for this iteration 'cnt'
                s{cnt} =  dataObject; 
                
            else
                % In this case the parent object is of the type 'java.util.LinkedHashMap'
                % Obtaining keys and values from the HashMap
                hashmap = dataObject;
                keySet = hashmap.keySet;
                keySet = keySet.toArray;
                values = hashmap.values;
                values = values.toArray;
                
                % Iterating through 'Keys' and unpacking 'Values' for those Keys which now
                % could again be of different classes
                % 
                % The following block handles classes 'java.util.LinkedHashMap'
                % & 'java.util.ArrayList' particularly and unpacks them
                % using the helper function 'value_unpack()'
                
                % Iterating through Keys in the Parent HashMap
                for i = 1:numel(keySet)
                    
                    % Checking for classes to handle
                    if isequal(class(values(i)),'java.util.LinkedHashMap')
                        
                        % call recursion function value_unpack() to get
                        % unpacked values for ith Key of the HashMap
                        % Key and Values of the ith KeySet iteration is assigned
                        % to the array of structs 's' for itertion number
                        % 'cnt' for number of dataObjects and in this case
                        % number of HashMaps. This decides the size of the
                        % array of structs 's' as well.
                        s{cnt}.(keySet(i)) = value_unpack(values(i));
                
                    elseif isequal(class(values(i)),'java.util.ArrayList')     
                        
                        % Values of the Hashmap for a given Key can also be
                        % a Java Array
                        % Iterating through the Array elements by creating
                        % an itertor itr for ith value
                        itr = values(i).iterator;
                        
                        % Tracking Array elements and iterations through
                        % another counter 'subcount' initialized to 0
                        subcount = 0;
                        
                        % Empty cell array is created with a MATLAB
                        % variable 'arrayval' to contain and return
                        % unpacked and marshalled array elements after
                        % iterating through them and unpacking using the
                        % helper function 'value_unpack()'
                        arrayval = {};
                        
                        % Iterating over the array values
                        while itr.hasNext
                            submap = itr.next;
                            % Incrementing through iterations
                            subcount = subcount + 1;
                            % Receiving unpacked values for the array
                            % element and not the entire array is being
                            % passed here
                            arrayval{subcount} = value_unpack(submap);
                        end
                        % Assigning cell array containing array elements of
                        % MATLAB based datatypes to the struct value for
                        % 'i'th Key of the hashmap number 'cnt'
                        s{cnt}.(keySet(i)) = arrayval;
                               
                    else
                        % Handling HashMap values for Keys where the values are 
                        % of datatypes such as 'string', 'char', 'double','single'.
                        % These values are handled directly by MATLAB Java Interface and
                        % are assigned as is to the struct 's' with 'i'th Key
                        % for this iteration 'cnt'
                        s{cnt}.(keySet(i)) = values(i);
                        
                    end %if - Hashmap Values Unpacking based on Class
                
                end %for - Iterating through Keys of the HashMap
                
            end % if - Testing Parent Object Class to be HashMap or Otherwise
        
        end % for - Iterating through the Parent Object Content
        
        % Returning array of structs 's' containing all Keys and Values for
        % multiple HashMaps encountered while iterating for the Parent
        % Object
        resp{n} = s;
    
    end % for - Iterating through single/multiple Parent Objects
    
    % Listing cell array of size 'n' with each element being an array of struct of size
    % 'cnt' being assigned to the return container 'results' defined as an
    % empty cell array if 'resp' is empty
    results = resp(:); 
else
    % Default of empty response returned using the container for response -
    % 'results = {}'
    results;
    
end % if - Test for non-empty response object
end

