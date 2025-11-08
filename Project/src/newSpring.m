classdef newSpring < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        L
        t
        w
        r
        th3 = 3*pi/4
        origin = [0;0];
        coords
    end

    methods
        function obj = newSpring(L, t, w, r)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.L = L;
            obj.t = t;
            obj.w = w;
            obj.r = r;
        end

        function makeCoords(obj)
            % all coords [x; y]
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            r_oA = [0; obj.t];
            r_AB = [obj.L; 0];
            r_BC = [cos(obj.th3); sin(obj.th3) + obj.r];
            r_CD = [obj.t*cos(obj.th3); obj.t*sin(obj.th3)];
            r_DF = [-obj.L*sin(obj.th3); obj.L*cos(obj.th3)];

            obj.coords.A = obj.origin + r_oA;
            obj.coords.B = obj.coords.A + r_AB;
            obj.coords.C = obj.coords.B + r_BC;
            obj.coords.D = obj.coords.C + r_CD;
            obj.coords.F = obj.coords.D + r_DF;
        end

        function fillCoords(obj)
            cs = obj.coords;

            gca;
            hold on;
            % For A-B-G1-G2
            xvals = [cs.A(1), cs.B(1), cs.B(1), cs.A(1)];
            yvals = [cs.A(2), cs.B(2), obj.origin(2), obj.origin(2)];
            fill(xvals, yvals, 'r');

            % for the curve
            theta_vals = linspace(-pi/2,obj.th3, 100);
            xvals_out = (obj.r + obj.t) * cos(theta_vals) + cs.B(1);
            xvals_in = obj.r * cos(theta_vals) + cs.B(1);

            yvals_out = (obj.r + obj.t) * sin(theta_vals) + obj.r + obj.t;
            yvals_in = obj.r * sin(theta_vals)  + cs.B(2) + obj.r;

            xvals = [xvals_in, flip(xvals_out)];
            yvals = [yvals_in, flip(yvals_out)];

            fill(xvals, yvals, 'g');
            axis equal


        end

        function dotPlotCoords(obj)
            dots = ['A', 'B', 'C', 'D', 'F'];
            gca;
            hold on

            for i = 1:numel(dots)
                plot(obj.coords.(dots(i))(1), obj.coords.(dots(i))(2), 'x')
            end

        end
    end
end