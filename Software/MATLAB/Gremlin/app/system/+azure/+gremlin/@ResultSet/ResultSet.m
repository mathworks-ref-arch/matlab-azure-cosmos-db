classdef ResultSet  < azure.objectgremlin
% RESULTSET is returned from the submission of a Gremlin script to the server and
% represents the results provided by the server.
%
% The results from the server are streamed into the ResultSet and therefore
% may not be available immediately. 
%
% As such, ResultSet provides access to a number of functions that help to work with the asynchronous nature of the data streaming back.
% Data from results is stored in an Result which can be used to retrieve the item once it is on the client side.
%
% Note: A ResultSet is a forward-only stream only so depending on how the methods are called and interacted with, it is possible to return partial bits of the total response (e.g. calling one() followed by all() will make it so that the List of results returned from all() have one Result missing from the total set as it was already retrieved by one().
%
% Ref : https://tinkerpop.apache.org/javadocs/current/full/org/apache/tinkerpop/gremlin/driver/ResultSet.html

% Copyright 2020 The MathWorks, Inc.

properties
end

methods
	%% Constructor 
	function obj = ResultSet(responsefromsubmit)
        obj.Handle = responsefromsubmit;                
	end
end%methods

end %class