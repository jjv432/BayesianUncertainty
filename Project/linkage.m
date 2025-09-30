classdef linkage
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        handedness = 'r'
        L
        l
        basePosition = [0, 0];
        corner1Position
        corner2Position
        endPosition
        fig1
        fig2
        fig3
        figs
        color
    end

    methods
        function obj = linkage(handedness, L, l, color)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.handedness = handedness;
            obj.L = L;
            obj.l = l;
            obj.color = color;
        end

        function obj = defineCoords(obj,theta)
            %METHOD1 Summary of this method goes here
            % Define where the beginning and end of links are
            % o (origin), b (base), c (corner), e (end)

            r_ob = obj.basePosition; % from o to b
            r_bc1 = obj.l * [cos(theta), sin(theta)]; % from b to c
            r_c1c2 = obj.L * [-sin(theta), cos(theta)]; % from c to c
            r_c2e = obj.l * [cos(theta), sin(theta)];
            
            if obj.handedness == 'l'
                r_c1c2 = r_c1c2 * [-1, 0; 0, -1];
            end

            obj.basePosition = r_ob;
            obj.corner1Position = obj.basePosition + r_bc1;
            obj.corner2Position = obj.corner1Position + r_c1c2;
            obj.endPosition = obj.corner2Position + r_c2e;

        end

        function obj = plotLinkage(obj, theta)
            % Update the coordinates
            obj = obj.defineCoords(theta);
            linewidth = 2;
            
            gca;
            hold on
            obj.figs(1) = plot([obj.basePosition(1), obj.corner1Position(1)], [obj.basePosition(2), obj.corner1Position(2)], obj.color, 'LineWidth', linewidth);
            obj.figs(2) = plot([obj.corner1Position(1), obj.corner2Position(1)], [obj.corner1Position(2), obj.corner2Position(2)], obj.color, 'LineWidth', linewidth);
            obj.figs(3) = plot([obj.corner2Position(1), obj.endPosition(1)], [obj.corner2Position(2), obj.endPosition(2)], obj.color, 'LineWidth', linewidth);
            
        end

    end
end