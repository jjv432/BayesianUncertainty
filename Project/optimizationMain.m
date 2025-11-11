clc; clear all; close all;
addpath("src");
%% Define the ideal response for the model
global idealM
idealKS = 400;
idealKD = 5;
idealM= 10;

yIdeal = getResponse(idealKS, idealKD);

%% Setting up GA

nvars = 5; % how many variables change

% current best: 0.1866    0.0147    1e-10    0.0382    0.0100

% lower and upper bounds for each variable
% L, t, w, r, ratio b/w kp and kd
LB= [0, 0, 0, 0, 0] + 1e-10;
UB= [0.2, 0.1, .01, 0.12, .02];
numparticles = 256;

options = optimoptions('ga', 'PopulationSize', numparticles, 'MaxGenerations', 400);

% Cost function handle
costFunctionHandle = @(freeParams) ModelSimulationCost(freeParams, yIdeal);

function Cost = ModelSimulationCost(fP, yIdeal)

    s = newSpring(fP(1), fP(2), fP(3), fP(4));
    s.kRatio = fP(5);
    s.predictKD();

    y = getResponse(s.ks, s.kd);

    Cost = sum( (y - yIdeal).^2 );

end
%% Run GA
% Running ga
A = [];
b = [];
Aeq = [];
beq = [];
nonlcon = [];
OptimizedParams = ga(costFunctionHandle, nvars, A, b, Aeq, beq, LB, UB, nonlcon, options);

L = OptimizedParams(1);
t = OptimizedParams(2);
w = OptimizedParams(3);
r = OptimizedParams(4);
optimizedS = newSpring(L, t, w, r);
optimizedS.kRatio = OptimizedParams(5);
optimizedS.predictKD();

[yOptimized, t_out] = getResponse(optimizedS.ks, optimizedS.kd);

figure;
hold on
plot(t_out, yIdeal, "LineWidth", 10)
plot(t_out, yOptimized, '*k')
hold off

% For E = 2e9:
% Best params found:  0.1093    0.0572    0.0000    0.0937    0.0100

figure()
optimizedS.fillCoords();