classdef spring < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        numElbows;
        connectorParams;
        elbowParams;
        connectors connector;
        elbows elbow;
    end

    methods
        function obj = spring(numElbows, connectorParams, elbowParams)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.numElbows = numElbows;
            obj.connectorParams = connectorParams;
            obj.elbowParams = elbowParams;
        end

        % function generateConnectors(obj)
        %
        %     % There's going to be n_elbows + 1 connectors
        %     length = obj.connectorParams.length;
        %     thickness = obj.connectorParams.thickness;
        %
        %     for i = 1:(obj.numElbows + 1)
        %         if ~mod(i, 2)
        %             side = 'r';
        %         else
        %             side = 'l';
        %         end
        %         cs(i) = connector(length, thickness, side).makeCoords();
        %
        %     end
        %     obj.connectors = cs;
        % end
        % function generateElbows(obj)
        %
        %     t = obj.elbowParams.t;
        %     w = obj.elbowParams.w;
        %     r = obj.elbowParams.r;
        %     E = obj.elbowParams.E;
        %
        %     for i = 1:obj.numElbows
        %         if ~mod(i, 2)
        %             side = 'r';
        %         else
        %             side = 'l';
        %         end
        %         es(i) = elbow('t', t, 'w', w, 'r', r, 'E', E, 'side', side).plotOriginalShape(0);
        %
        %     end
        %     obj.elbows = es;
        % end

        function constructSpring(obj)
            % This is where everything is getting put together
            cl = obj.connectorParams.length;
            ct = obj.connectorParams.thickness;

            t = obj.elbowParams.t;
            w = obj.elbowParams.w;
            r = obj.elbowParams.r;
            E = obj.elbowParams.E;

            obj.connectors(1) = connector(cl, ct, 'l').makeCoords();
            x_offset = obj.connectors(1).coords(1, end);
            y_offset = obj.connectors(1).coords(2, end);

            % Now, make the rest
            for i = 1:obj.numElbows
                if ~mod(i, 2)
                    side = 'r';
                else
                    side = 'l';
                end
                % First, make the elbow
                obj.elbows(i) = elbow('t', t, 'w', w, 'r', r, 'E', E, 'side', side);
                obj.elbows(i).x_offset = x_offset;
                obj.elbows(i).y_offset = y_offset;
                obj.elbows(i).makeCoords();

                % now make the connector
                % The x offset doesn't change, just the y by r
                y_offset = y_offset + r;

                

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