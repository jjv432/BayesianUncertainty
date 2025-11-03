clc;  clear all; close all;

t_vals = 0:.01:3;

P = sin(t_vals);
c = exp(t_vals);

theta = [P; c];

h = 1e-12;

%% Complex Step

z_p_P = complexStep(theta, 1, h, t_vals);
z_p_c = complexStep(theta, 2, h, t_vals);

z_ps = [z_p_P, z_p_c];
names = ['P', 'c'];

%% Analytical
syms P c t
t0 = 0;
z = (P/c^2) * (exp(-c*(t-t0)) - 1 + c*(t-t0));

% dz/dP
dz_dP = simplify(diff(z, P));

%dz/dc
dz_dc = simplify(diff(z, c));

z_ = zeros(2, numel(t_vals));

for i = 1:numel(t_vals)
    z_(1, i) = subs(dz_dP, [P, c, t], [theta(1, i), theta(2, i), t_vals(i)]);
    z_(2, i) = subs(dz_dc, [P, c, t], [theta(1, i), theta(2, i), t_vals(i)]);
end


%% Plotting
figure()
for i = 1:2
    subplot(2, 1, i)
    hold on 
    plot(t_vals, z_ps(:, i), 'k',  'DisplayName', 'Complex Step', 'LineWidth', 5);
    plot(t_vals, z_(i,:), 'r.', 'DisplayName', 'Analytical', 'LineWidth', 1);
    hold off
    legend()
    title(names(i));
end


%% Functions
function z_p = complexStep(thetas, pos, h, t_vals)
    z_p = zeros(numel(t_vals), 1);
    thetas(pos, :) = thetas(pos, :) + 1i * h;

    for i = 1:numel(t_vals)
        t_val = t_vals(i);
        z = xfr(thetas(:, i), t_val);
        z_p(i) = imag(z) / h;
    end

end

function z = xfr(theta, t)
    t0 = 0;
    P = theta(1);
    c = theta(2);

    z = (P/c^2) * (exp(-c*(t-t0)) - 1 + c*(t-t0));

end