clc; clearvars; close all;

%% General
syms t x var0 X var(t)

P = (1 / sqrt(2 * pi * var(t))) * exp( -((x - X)^2) / (2*var(t)));

%% Constants (for later)
XFixed = 5;
x0 = 3;
var0Fixed = 20;

%% Take Derivatives

% Temporal
f1 = simplify(diff(P, t));
fprintf("The temporal derivative is: \n\n");
pretty(f1);

% Spacial
f2 = simplify(diff(diff(P, x), x));
fprintf("The spacial derivative is: \n\n");
pretty(f2);

% Set the correct relation for var(t) and var0
f1 = subs(f1, [X, var(t)], [XFixed, var0*t]);
f2 = subs(f2, [X, var(t)], [XFixed, var0*t]);

%% Ratio

% Find the ratio alpha between f2 and f1
alpha = simplify(f2 ./ f1);
alpha = subs(alpha, x, x0);
fprintf("The diffusion constant \x03B1 between the derivatives is: \n\n");
pretty(alpha);

%% Plotting
tPlot = linspace(0.1, 2, 100);

% Substitute fixed values in so that it can be plotted
f1Plot = subs(f1, [var0, x], [var0Fixed, 5*t]);
f1Plot = double(subs(f1Plot, t, tPlot));

f2Plot = subs(f2, [var0, x], [var0Fixed, 5*t]);
f2Plot = double(subs(f2Plot, t, tPlot));

% Plot
lw = 3;
figure();
hold on
plot(tPlot, f1Plot, '--k', 'DisplayName', 'Temporal Der.', 'LineWidth', lw)
plot(tPlot, f2Plot, '--r', 'DisplayName', 'Spacial Der.', 'LineWidth', lw)
plot(tPlot, f2Plot./f1Plot, '.b', 'DisplayName', 'Computed \alpha', 'MarkerSize', 20)
yline(2/var0Fixed, 'c', 'DisplayName', 'Expected \alpha', 'LineWidth', lw )
grid on
hold off
legend()
title("Spacial and Temporal Derivatives with Variance " + string(var0Fixed));