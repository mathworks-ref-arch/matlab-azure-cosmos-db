function setDataType(obj, dataType)
% SETDATATYPE

% Copyright 2019 The MathWorks, Inc.


logObj = Logger.getLogger();

if ~isa(dataType, 'azure.documentdb.DataType')
    write(logObj,'error','dataType argument not of type azure.documentdb.DataType');
end

switch dataType
    case azure.documentdb.DataType.LineString
        obj.Handle = com.microsoft.azure.documentdb.RangeIndex(com.microsoft.azure.documentdb.DataType.LineString);
    case azure.documentdb.DataType.MultiPolygon
        obj.Handle = com.microsoft.azure.documentdb.RangeIndex(com.microsoft.azure.documentdb.DataType.MultiPolygon);
    case azure.documentdb.DataType.Number
        obj.Handle = com.microsoft.azure.documentdb.RangeIndex(com.microsoft.azure.documentdb.DataType.Number);
    case azure.documentdb.DataType.Point
        obj.Handle = com.microsoft.azure.documentdb.RangeIndex(com.microsoft.azure.documentdb.DataType.Point);
    case azure.documentdb.DataType.Polygon
        obj.Handle = com.microsoft.azure.documentdb.RangeIndex(com.microsoft.azure.documentdb.DataType.Polygon);
    case azure.documentdb.DataType.String
        obj.Handle = com.microsoft.azure.documentdb.RangeIndex(com.microsoft.azure.documentdb.DataType.String);
    otherwise
        write(logObj,'error','Invalid dataType arguments');
end
end
