classdef IndexKind < azure.object
    % IndexKind Enumeration for the kinds of Index
    %
    % Example:
    %    numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);

    % Copyright 2019 The MathWorks, Inc.

    enumeration
        Hash
        Range
        Spatial
    end

end %class
