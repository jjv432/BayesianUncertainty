classdef newSpring < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        L
        t
        w
        r
        th3 = pi/2 * 1.2
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
            r_BC = [obj.r*cos(obj.th3); obj.r*sin(obj.th3) + obj.r];
            r_CD = [obj.t*cos(obj.th3); obj.t*sin(obj.th3)];
            r_DE = [-obj.L*sin(obj.th3); obj.L*cos(obj.th3)];
            r_EF = [-obj.t*cos(obj.th3); -obj.t*sin(obj.th3)];
            r_FH = [(obj.r + obj.t)*cos(obj.th3); (obj.r + obj.t)*sin(obj.th3) + obj.r + obj.t];
            r_HI = [0; -obj.t];
            r_IJ = [obj.L; 0];
            r_JK = [0; obj.t];

            obj.coords.A = obj.origin + r_oA;
            obj.coords.B = obj.coords.A + r_AB;
            obj.coords.C = obj.coords.B + r_BC;
            obj.coords.D = obj.coords.C + r_CD;
            obj.coords.E = obj.coords.D + r_DE;
            obj.coords.F = obj.coords.E + r_EF;
            obj.coords.H = obj.coords.F + r_FH;
            obj.coords.I = obj.coords.H + r_HI;
            obj.coords.J = obj.coords.I + r_IJ;
            obj.coords.K = obj.coords.J + r_JK;
        end

        function fillCoords(obj)

            obj.makeCoords();
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

            xvals_curve = [xvals_in, flip(xvals_out)];
            yvals_curve = [yvals_in, flip(yvals_out)];

            fill(xvals_curve, yvals_curve, 'g');
            axis equal

            % For D-E-F-C
            xvals = [cs.D(1), cs.E(1), cs.F(1), cs.C(1)];
            yvals = [cs.D(2), cs.E(2), cs.F(2), cs.C(2)];
            fill(xvals, yvals, 'r');

            % for the next curve
            theta_vals = linspace(obj.th3+pi , pi/2, 100);

            xvals_out = (obj.r + obj.t) * cos(theta_vals);
            xvals_out = xvals_out - xvals_out(1) + cs.F(1);

            xvals_in = obj.r * cos(theta_vals);
            xvals_in = xvals_in - xvals_in(1) + cs.E(1);

            yvals_out = (obj.r + obj.t) * sin(theta_vals);
            yvals_out = yvals_out - yvals_out(1) + cs.F(2);

            yvals_in = obj.r * sin(theta_vals);          
            yvals_in = yvals_in - yvals_in(1) + cs.E(2);

            xvals_curve = [xvals_in, flip(xvals_out)];
            yvals_curve = [yvals_in, flip(yvals_out)];

            fill(xvals_curve, yvals_curve, 'g');
            axis equal

            % For H-I-J-K
            xvals = [cs.H(1), cs.I(1), cs.J(1), cs.K(1)];
            yvals = [cs.H(2), cs.I(2), cs.J(2), cs.K(2)];
            fill(xvals, yvals, 'r');

        end
    end
end