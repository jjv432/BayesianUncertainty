clc; clear all; close all;

%% General
syms t x(t) var0 X
var = var0*t;

P = (1 / sqrt(2 * pi * var)) * exp( -(x(t) - X)^2 / (2*var));
tPlot = linspace(0.1, 20, 1000);
var0Fixed = 5;
XFixed = 5;
%% First Partial

% Evaluate the derivative
f1 = diff(P, t);
f1 = simplify(f1);

% Now, make substitutions so that plots can be generated
f1Plot = subs(f1, var0, var0Fixed);
f1Plot = subs(f1Plot, X, XFixed);
f1Plot = subs(f1Plot, x, 2*t);
f1Plot = double(subs(f1Plot, t, tPlot));

%% Second Partial

% Evaluate the derivative
f2 = diff(diff(P, x(t)), x(t));
f2 = simplify(f2);

% Now, make substitutions so that plots can be generated
f2Plot = subs(f2, var0, var0Fixed);
f2Plot = subs(f2Plot, X, XFixed);
f2Plot = subs(f2Plot, x, 2*t);
f2Plot = double(subs(f2Plot, t, tPlot));

%% Coefficient

alpha = simplify(f1 ./ f2);
pretty(alpha)

%% Plotting

figure()
hold on;
plot(tPlot, f1Plot);
plot(tPlot, f2Plot);
hold off