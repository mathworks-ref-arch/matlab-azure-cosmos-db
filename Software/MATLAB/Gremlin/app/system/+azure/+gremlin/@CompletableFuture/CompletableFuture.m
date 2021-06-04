classdef CompletableFuture  < azure.objectgremlin
% COMPLETABLEFUTURE A Future that may be explicitly completed (setting its value and status), and may be used as a CompletionStage, supporting dependent functions and actions that trigger upon its completion.
%
% Ref: https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CompletableFuture.html

% Copyright 2020 The MathWorks, Inc.

properties
end

methods
	%% Constructor 
	function obj = CompletableFuture(completablefutureJ)
        obj.Handle = completablefutureJ;
	end
end

end %class