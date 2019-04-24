classdef DataType < azure.object
    % DATATYPE Enumeration for data types in Cosmos DB.

    % stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
    % numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);

    % Copyright 2019 The MathWorks, Inc.

    enumeration
        LineString
        MultiPolygon
        Number
        Point
        Polygon
        String
    end

end %class
