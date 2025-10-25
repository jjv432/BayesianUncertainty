clc; close all; clearvars

F_vals = linspace(0, 500, 50);
theta_vals = predictAnglularChange(F_vals)

plot(F_vals, theta_vals);

% % Original coordinates
% r_o = r + t;
% r_i = r;
% thetas = linspace(-pi/2, pi/2, 100);
% 
% xvals_in = r_i * cos(thetas);
% yvals_in = r_i * sin(thetas);
% 
% xvals_out = r_o * cos(thetas);
% yvals_out = r_o * sin(thetas);
% 
% x_vals = [xvals_in, flip(xvals_out)];
% y_vals = [yvals_in, flip(yvals_out)];
% 
% 
% figure();
% hold on
% scatter([x_top, x_in], [y_top, y_in])
% fill(x_vals, y_vals, 'r');
% axis equal

function theta_3 = predictAnglularChange(F_load)
    width = 10; %cm
    t = 2; %cm

    I = (1/12) * width * t;

    r = 2; %cm

    M = F_load *(r + t/2);

    stress = M * (t/2) / I;
    E = 1e5; %Pa
    strain = stress / E;

    l_od_0 = (pi/2) * (r + t);
    l_id_0 = (pi/2) * r;

    theta_od = (l_od_0 + strain) / (r + t);
    theta_id = (l_id_0 - strain) / (r);

    theta_1 = .5 * (theta_id + pi/2);
    theta_2 = .5 * (theta_od + pi/2);

    x_top = (r + t) * cos(theta_2);
    y_top = (r + t) * sin(theta_2);

    x_in = r * cos(theta_1);
    y_in = r * sin(theta_1);

    theta_3 = atan2((y_top - y_in), (x_top - x_in));



end