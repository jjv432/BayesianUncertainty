classdef newSpring < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        L
        t
        w
        r
        E = 1e6;
        th3 = pi/2 * 1.2
        origin = [0;0];
        coords
        numElbows = 2;
        ks
        kd
        kRatio
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


            obj.coords.G1 = [0; 0];
            obj.coords.G2 = [obj.L; 0];
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

            gca;
            hold on;

            % For A-B-G1-G2
            obj.fillConnector('A', 'B', "G2", "G1");

            % for the curve
            obj.fillElbow('B', "G2", 'r');

            % For D-E-F-C
            obj.fillConnector('D', 'E', 'F', 'C');

            % for the next curve
            obj.fillElbow('E', 'F', 'l');

            % For H-I-J-K
            obj.fillConnector('H', 'I', 'J', 'K');

            axis equal
        end

        function fillConnector(obj, aa, bb, cc, dd)
            cs = obj.coords;

            xvals = [cs.(aa)(1), cs.(bb)(1), cs.(cc)(1), cs.(dd)(1)];
            yvals = [cs.(aa)(2), cs.(bb)(2), cs.(cc)(2), cs.(dd)(2)];
            fill(xvals, yvals, 'r');

        end

        function fillElbow(obj, topCon, botCon, side)
            cs = obj.coords;

            if side == 'r'
                theta_vals = linspace(-pi/2,obj.th3, 100);
            elseif side == 'l'
                theta_vals = linspace(obj.th3+pi , pi/2, 100);
            end

            xvals_out = (obj.r + obj.t) * cos(theta_vals);
            xvals_out = xvals_out - xvals_out(1) + cs.(botCon)(1);

            xvals_in = obj.r * cos(theta_vals);
            xvals_in = xvals_in - xvals_in(1) + cs.(topCon)(1);

            yvals_out = (obj.r + obj.t) * sin(theta_vals);
            yvals_out = yvals_out - yvals_out(1) + cs.(botCon)(2);

            yvals_in = obj.r * sin(theta_vals);
            yvals_in = yvals_in - yvals_in(1) + cs.(topCon)(2);

            xvals_curve = [xvals_in, flip(xvals_out)];
            yvals_curve = [yvals_in, flip(yvals_out)];

            fill(xvals_curve, yvals_curve, 'g');


        end

        function th3 = th3Response(obj, F_load)
            F_load = F_load / obj.numElbows;

            I = (1/12) * obj.w * obj.t;

            % M = F_load *(obj.r + obj.t/2);
            M = F_load *(obj.r);

            stress = M * (obj.t/2) / I;

            strain = stress / obj.E;
            
            % This is the small angle of th3. as in less than pi/2
            th3 = strain / (obj.r + obj.t);
            

        end

        function predictKD(obj)
            testForce = 1000;
            th3_ = wrapTo2Pi(obj.th3Response(testForce));
            obj.ks = testForce / th3_;
            obj.kd = obj.ks * obj.kRatio; % FIX THIS
            obj.th3 = pi/2;
        end

        function th3_ = inverseKinematics(obj, cur_y)
            obj.makeCoords;
            cs = obj.coords;

            % Go from a known y to th3

            natural_length = (2 * (obj.r + obj.t)) * obj.numElbows;


            th3_ = pi/2-(cur_y + natural_length - cs.B(2) - 2*obj.r - obj.t - obj.L ) / (2*obj.r + obj.t);       
            
            obj.th3 = th3_;

        end
    end
end