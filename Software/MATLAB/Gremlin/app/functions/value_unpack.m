function structval = value_unpack(valueset)
%VALUE_UNPACK Returns unpacked and MATLAB versions of Java Hashmaps and ArrayLists 
%
% This function is used in recursion to unpack graph objects with
% properties. The traversal strategy is depth first(instead of breadth
% first)
%
% Package methods consuming this function include @ResultSet.get() and
% @CompletableFuture.get()
% 
% Note: This function is not independently available for use outside the
% get() methods mentioned above and is limited to unpacking result types this
% package has been tested for.
%

% (Copyright 2020, The MathWorks, Inc.)



if isequal(size(valueset),0)
    % create empty struct to return and also maintain the consisitency for
    % the return type of this function as struct only
    structval = struct;
    
else
    % Values received in this function are values pertaining to either a
    % HashMap Key or a Java array element
    %
    % Data Marshalling rules for the following datatypes through a switch
    % case has been implemented:
    %     1. 'java.util.LinkedHashMap'
    %     2. 'java.util.ArrayList'
    %     3.  Others - 'double', 'single', 'char', 'string', 'boolean'
    switch class(valueset)
        case 'java.util.LinkedHashMap'
            % Look for size
            for i = 1:numel(valueset)
                v = valueset(i);             
                % Value is a another Hashmap with keys and values
                hashmap = v;
                % Accessing Keys and Values for this recursion
                keySet = hashmap.keySet;
                keySet = keySet.toArray;
                values = hashmap.values;
                values = values.toArray;
                % Iterating through KeySet for this hashmap
                for j = 1:numel(keySet)
                    
                    % Call unpack_values() as a recursion on the values
                    % This call will lead to recursions of this function
                    unpackedval = value_unpack(values(j));
                    
                    % Unpacked values will be only of type 
                    % 'single', 'double', 'char', 'string' or 'boolean'
                    % returned from case otherwise
                    % If the values(j) were of type hashmap or array it
                    % will keep moving through switch cases and invoking
                    % recursions. 
                    structval.(keySet(j)) = unpackedval;
                    
                end % Finishing KeySet iteration
                
            end % finish iterating through values received for unpacking
            
        case 'java.util.ArrayList'
            
            % This  case is invoked by two conditions:
            %
            % 1. Recursion of the function value_unpack(), 
            %    if values in the HashMap case for a given key is of the type Java Array        
            %
            % 2. Method get() calls value_unpack() if HashMap value is of the type Java Array
            
            for i = 1:numel(valueset)
                values = valueset(i);
                itr = values.iterator;
                while itr.hasNext
                    % Accessing Array element
                    arrayvalue = itr.next;
                          
                    % Unpack or marshall an array element in recursion 
                    % The Array element here could be again an array,
                    % hasmap or otherwise
                    
                    % If it is an array again, this case will keep getting
                    % invoked via recursion till we reach an array element
                    % which is either a hashmap or case otherwise
                    unpackedval = value_unpack(arrayvalue);
                    
                    % You reach this part of the code only if the array element
                    % is not of class 'java.util.ArrayList' or a'HashMap'
                    % but of classes received in case otherwise.
                    structval = unpackedval;
                    
                    %if ~arrayvalue.isEmpty end  % Use if you need to see
                    %if array element is empty
                end
            end
            
        otherwise
            % This case does not invoke recursions 
            % It is the return for the last recursion of a possible series
            % The retruned value will be the unpacked values for the above
            % 2 cases
            structval = valueset;
    
    end%switch
    
 end%function
   
    
%% Design strategy for unpacking     
%     for i = 1:numel(valueset)
%         v = valueset(i);             
%         hashmap = v;
%         keySet = hashmap.keySet;
%         keySet = keySet.toArray;
%         values = hashmap.values;
%         values = values.toArray;
%         
%         for j = 1:numel(values)
%             if isequal(class(values(j)),'java.util.LinkedHashMap')
%                 substructval = value_unpack(values(j));
%                 structval.(keySet(j)) = substructval;
%             elseif isequal(class(values(j)),'java.util.ArrayList')
%                 itr = values(j).iterator;
%                 while itr.hasNext
%                     submap = itr.next;
%                     substructval = value_unpack(submap);
%                     structval.(keySet(j)) = substructval;
%                 end
%             else
%                 structval.(keySet(j)) = values(j);
%             end
%         end%for
%         
%         %end%for iterating through hashmap keys and values
%         
%     end%for iterating through valueset
% end %if

