classdef connector < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        length = 4;
        thickness = 1;
        coords = [];
        side = 'l'
        x = 0
        y = 0
        theta = 0
    end

    methods
        function obj = connector(length, thickness, side)
            obj.length = length;
            obj.thickness = thickness;
            obj.side = side;
            
        end

        function obj = makeCoords(obj)
            % Make the original coordinates of the object
            % Based on the left handside - center of the connector

            x_coords = obj.length * [0, 0, 1, 1]; 
            y_coords = obj.thickness/2 * [-1, 1, 1, -1]; 

            if obj.side == 'r'
                x_coords = -x_coords;
            end

            obj.coords = [x_coords; y_coords];            
            
        end

        function obj = transformCoords(obj)

            if isempty(obj.coords)
                obj.makeCoords();
            end            

            obj.coords = [cos(obj.theta), -sin(obj.theta); sin(obj.theta), cos(obj.theta)] *  obj.coords;    
            obj.coords = obj.coords + [obj.x;obj.y]; % translation

        end

        function plotConnector(obj)
            obj.transformCoords();
            gca;
            fill(obj.coords(1, :), obj.coords(2, :), 'r');
            axis equal

        end
    end
end