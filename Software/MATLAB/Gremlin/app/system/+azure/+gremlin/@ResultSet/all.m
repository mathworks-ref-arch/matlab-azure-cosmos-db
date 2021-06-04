function completablefutureresults = all(obj,varargin)
% The returned CompletableFuture completes when all reads are complete for this request
% and the entire result has been accounted for on the client.
%
%    CompletableFuture<List<Result>>	resultset.all()

%(Copyright 2020, The MathWorks, Inc.)

resultsets = obj.Handle;
completablefutureresults = {};

for i = 1: numel(resultsets)
    resultset = resultsets{i};
    completablefutureresults{i} = resultset.all;
    if resultset.allItemsAvailable
      %  fprintf('All results available');
    end
end
completablefutureresults = azure.gremlin.CompletableFuture(completablefutureresults);
end
