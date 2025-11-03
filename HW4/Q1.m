clc;  clearvars; close all;

% z= K / (1 + (K/z0 - 1) exp(rt))

% z' = IM[z(x + ih)] / h
t_vals = 0:.01:3;

r = sin(t_vals);
K = exp(t_vals);
z0 = 3 * ones(1, numel(t_vals));
theta = [r; K; z0];

h = 1e-12;

%% Complex Step

z_p_r = complexStep(theta, 1, h, t_vals);
z_p_K = complexStep(theta, 2, h, t_vals);
z_p_z0 = complexStep(theta, 3, h, t_vals);

z_ps = [z_p_r, z_p_K, z_p_z0];
names = ['R', 'K', "Z0"];

%% Analytical
syms r K z0 t

z = K / (1 + (K/z0 - 1) * exp(r * t));

% dz/dr
dz_dr = simplify(diff(z, r));

%dz/dK
dz_dK = simplify(diff(z, K));

% dZ/dz0
dz_dZ0 = simplify(diff(z, z0));

z_ = zeros(3, numel(t_vals));

for i = 1:numel(t_vals)
    z_(1, i) = subs(dz_dr, [r, K, z0, t], [theta(1, i), theta(2, i), theta(3, i), t_vals(i)]);
    z_(2, i) = subs(dz_dK, [r, K, z0, t], [theta(1, i), theta(2, i), theta(3, i), t_vals(i)]);
    z_(3, i) = subs(dz_dZ0, [r, K, z0, t], [theta(1, i), theta(2, i), theta(3, i), t_vals(i)]);
end


%% Plotting
figure()
for i = 1:3
    subplot(2, 2, i)
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
    r = theta(1);
    K = theta(2);
    z0 = theta(3);

    z = K / (1 + (K/z0 - 1) * exp(r * t));

end