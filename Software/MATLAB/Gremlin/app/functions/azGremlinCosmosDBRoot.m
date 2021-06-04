function [str] = azGremlinCosmosDBRoot(varargin)
% AZGREMLINCOSMOSDBROOT Helper function to locate the Azure Cosmos DB interface
%
% Locate the installation of the Azure tooling to allow easier construction
% of absolute paths to the required dependencies.

%(Copyright 2020, The MathWorks, Inc.)

str = fileparts(fileparts(fileparts(mfilename('fullpath'))));

end %function
