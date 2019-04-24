classdef RangeIndex < azure.object
% RANGEINDEX Represents a range index in Cosmos DB
%
% Examples:
%    stringRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.String,-1);
%    numberRangeIndex = azure.documentdb.RangeIndex(azure.documentdb.DataType.Number,-1);
%    indexes = {stringRangeIndex,numberRangeIndex};
%    includedPath.setIndexes(indexes);

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = RangeIndex(dataType, varargin)
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

        if numel(varargin) > 1
            write(logObj,'error','Invalid number of arguments');
        elseif numel(varargin) == 1
            if ~(isnumeric(varargin{1}) && isscalar(varargin{1}))
                write(logObj,'error','precision argument not of type numeric scalar');
            else
                obj.Handle.setPrecision(int32(varargin{1}));
            end
        else
            % 0 arguments do nothing
        end
    end %function
end %methods
end %class
