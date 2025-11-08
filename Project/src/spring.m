classdef spring < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        numElbows;
        connectorParams;
        elbowParams;
        connectors = [];
        elbows = [];
    end

    methods
        function obj = spring(numElbows, connectorParams, elbowParams)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.numElbows = numElbows;
            obj.connectorParams = connectorParams;
            obj.elbowParams = elbowParams;
        end

        function generateConnectors(obj)

            % There's going to be n_elbows + 1 connectors
            length = obj.connectorParams.length;
            thickness = obj.connectorParams.thickness;

            for i = 1:(obj.numElbows + 1)
                if ~mod(i, 2)
                    side = 'r';
                else
                    side = 'l';
                end
                cs(i) = connector(length, thickness, side).makeCoords();

            end
            obj.connectors = cs;
        end
        function generateElbows(obj)

            t = obj.elbowParams.t;
            w = obj.elbowParams.w;
            r = obj.elbowParams.r;
            E = obj.elbowParams.E;

            for i = 1:obj.numElbows 
                if ~mod(i, 2)
                    side = 'r';
                else
                    side = 'l';
                end
                es(i) = elbow('t', t, 'w', w, 'r', r, 'E', E, 'side', side).plotOriginalShape(0);

            end
            obj.elbows = es;
        end

        function constructSpring(obj)
            % This is where everything is getting put together

            curConnector = obj.connectors(1);
            x_end = curConnector.coords(1, end);
            y_end = curConnector.coords(2, end);
            for i = 2%:numel(obj.connectors)
                curElbow = obj.elbows(i-1);
                curElbow.x_offset = x_end;
                curElbow.y_offset = y_end;

                curElbow.plotOriginalShape(0);

                obj.elbows(i-1) = curElbow;

            end
            
        end
        
        function plotSpring(obj)
            gca;
            hold on
            for i = 1:numel(obj.connectors)
                obj.connectors(i).plotConnector
            end
            for i = 1:numel(obj.elbows)
                obj.elbows(i).plotOriginalShape(1);
            end
        end
    end
end