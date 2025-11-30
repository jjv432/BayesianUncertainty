classdef newSpring < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        L_
        t_
        w_
        r_
        E_ = 2e9;
        th3_ = pi/2 * 1.2
        origin_ = [0;0];
        coords_
        numElbows_ = 2;
        ks_
        kd_
        kRatio_
        complianceMatrix_ = [];
        Fd_DivU2_
    end

    methods
        function obj = newSpring(L, t, w, r)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.L_ = L;
            obj.t_ = t;
            obj.w_ = w;
            obj.r_ = r;
            obj.makeComplianceMatrix();
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%% PLOTTING METHODS %%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function makeCoords(obj)
            % all coords [x; y]
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here

            r_oA = [0; obj.t_];
            r_AB = [obj.L_; 0];
            r_BC = [obj.r_*cos(obj.th3_); obj.r_*sin(obj.th3_) + obj.r_];
            r_CD = [obj.t_*cos(obj.th3_); obj.t_*sin(obj.th3_)];
            r_DE = [-obj.L_*sin(obj.th3_); obj.L_*cos(obj.th3_)];
            r_EF = [-obj.t_*cos(obj.th3_); -obj.t_*sin(obj.th3_)];
            r_FH = [(obj.r_ + obj.t_)*cos(obj.th3_); (obj.r_ + obj.t_)*sin(obj.th3_) + obj.r_ + obj.t_];
            r_HI = [0; -obj.t_];
            r_IJ = [obj.L_; 0];
            r_JK = [0; obj.t_];


            obj.coords_.G1 = [0; 0];
            obj.coords_.G2 = [obj.L_; 0];
            obj.coords_.A = obj.origin_ + r_oA;
            obj.coords_.B = obj.coords_.A + r_AB;
            obj.coords_.C = obj.coords_.B + r_BC;
            obj.coords_.D = obj.coords_.C + r_CD;
            obj.coords_.E = obj.coords_.D + r_DE;
            obj.coords_.F = obj.coords_.E + r_EF;
            obj.coords_.H = obj.coords_.F + r_FH;
            obj.coords_.I = obj.coords_.H + r_HI;
            obj.coords_.J = obj.coords_.I + r_IJ;
            obj.coords_.K = obj.coords_.J + r_JK;
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
            cs = obj.coords_;

            xvals = [cs.(aa)(1), cs.(bb)(1), cs.(cc)(1), cs.(dd)(1)];
            yvals = [cs.(aa)(2), cs.(bb)(2), cs.(cc)(2), cs.(dd)(2)];
            fill(xvals, yvals, 'r');

        end

        function fillElbow(obj, topCon, botCon, side)
            cs = obj.coords_;

            if side == 'r'
                theta_vals = linspace(-pi/2,obj.th3_, 100);
            elseif side == 'l'
                theta_vals = linspace(obj.th3_+pi , pi/2, 100);
            end

            xvals_out = (obj.r_ + obj.t_) * cos(theta_vals);
            xvals_out = xvals_out - xvals_out(1) + cs.(botCon)(1);

            xvals_in = obj.r_ * cos(theta_vals);
            xvals_in = xvals_in - xvals_in(1) + cs.(topCon)(1);

            yvals_out = (obj.r_ + obj.t_) * sin(theta_vals);
            yvals_out = yvals_out - yvals_out(1) + cs.(botCon)(2);

            yvals_in = obj.r_ * sin(theta_vals);
            yvals_in = yvals_in - yvals_in(1) + cs.(topCon)(2);

            xvals_curve = [xvals_in, flip(xvals_out)];
            yvals_curve = [yvals_in, flip(yvals_out)];

            fill(xvals_curve, yvals_curve, 'g');


        end

        function th3_ = inverseKinematics(obj, cur_y)
            obj.makeCoords;
            cs = obj.coords_;

            % Go from a known y to th3

            natural_length = (2 * (obj.r_ + obj.t_)) * obj.numElbows_;


            th3_ = pi/2-(cur_y + natural_length - cs.B(2) - 2*obj.r_ - obj.t_ - obj.L_ ) / (2*obj.r_ + obj.t_);       
            
            obj.th3_ = th3_;

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%% DYNAMICS METHODS %%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function predictKDMems(obj)
            % Ref: Wang, Zhang, Zhang 2018
            % Update stiffness
            obj.makeComplianceMatrix();

            % Update drag
            predictDragForceFnU2(obj);
        end

        function predictDragForceFnU2(obj)
            Cd = 1.05;
            A = 2*obj.L_*obj.w_;
            rho = 1.225;

            obj.Fd_DivU2_ = .5 * rho * Cd * A;

        end

        function makeComplianceMatrix(obj)
            l = obj.L_;
            R = obj.r_;
            t = obj.t_;
            w = obj.w_;
            E = obj.E_;

            m = 432*l^2*R^4 - 144*R^6 + 60*l^4*R^2 + 27*pi^2*R^6 ...
                + 4*l^4*t^2 + 108*pi*l^3*R^3 + 18*l^2*pi^2*R^4 ...
                + 24*l^2*R^2*t^2 + 133*pi*l*R^5 + 3*pi*l*R^3*t^2 ...
                + 6*pi*l^3*R*t^2;


            a11 = (9*pi*R^3 + 24*l*R^2 + l*t^2)*E*w*t^3;
            a21 = -3*(l^2 + pi*l*R + 2*R^2)*R*E*w*t^3;
            a31 = 3*(l^2 + pi*l*R + 2*R^2)*R^2 * E*w*t^3;
            b11 = 4*m;
            b21 = 2*m;
            b31 = m;

            a12 = -3*(l^2 + pi*l*R + 2*R^2)*R*E*w*t^3;
            a22 = (4*l^3 + 6*pi*l^2*R + 24*l*R^2 + 3*pi*R^3)*E*w*t^3;
            a32 = -(4*l^3 + 6*pi*l^2*R + 24*l*R^2 + 3*pi*R^3)*E*w*t^3;
            b12 = 2*m;
            b22 = 4*m;
            b32 = 2*m;

            a13 = 3*(l^2 + pi*l*R + 2*R^2)*R^2 * E*w*t^3;
            a23 = -(4*l^3 + 6*pi*l^2*R + 24*l*R^2 + 3*pi*R^3)*E*w*t^3;
            a33 = (1584*l^2*R^4 - 144*R^6 + 252*l^4*R^2 + 99*pi^2*R^6 ...
                  + 4*l^4*t^2 + 492*pi*l^3*R^3 + 162*l^2*pi^2*R^4 ...
                  + 24*l^2*R^2*t^2 + 864*pi*l*R^5 + 3*pi*l*R^3*t^2 ...
                  + 6*pi*l^3*R*t^2) * E*w*t^3;
            b13 = m;
            b23 = 2*m;
            b33 = 24*(2*l + pi*R)*m;

            aMatrix = [a11, a12, a13; a21, a22, a23; a31, a32, a33];
            bMatrix = [b11, b12, b13; b21, b22, b23; b31, b32, b33];

            cM = aMatrix ./ bMatrix;
            
            obj.complianceMatrix_ = cM;
        end

        
    end
end