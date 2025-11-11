clc; clear; close all;
addpath("src");
%% Define the ideal response for the model

idealKS = 200;
idealKD = 2;
global idealM B C D u simTime yIdeal
idealM= 10;

A = [0, 1; -idealKS/idealM, -idealKD/idealM];
B = [0; 1/idealM];
C = [1 0];
D = [0];

idealSys = ss(A, B, C, D);

simTime = linspace(0, 5, 2000);

u = -idealM*9.81*ones(numel(simTime), 1);

[yIdeal, t_out, x] = lsim(idealSys, u, simTime);

%% Set up the spring object
% Naive 'trust' in the model.

% All of these units are metric
L = .05;
t = L * (1/10);
w = L * 10;
r = L * (1/2.5);
m = 100;

s = newSpring(L, t, w, r);

s.predictKD();

%% Setting up GA

nvars = 5; % how many variables change

% lower and upper bounds for each variable
% L, t, w, r, ratio b/w kp and kd
LB= [0.01 0.01 .05 .001, 1e-10];
LB= [0, 0, 0, 0, 0] + 1e-12;
UB= [0.4, 0.4, 4, 0.16, 2];
numparticles = 64;

options = optimoptions('ga', 'PopulationSize', numparticles, 'UseParallel', false, 'MaxGenerations', 200);

% Cost function handle
costFunctionHandle = @(freeParams) ModelSimulationCost(freeParams);

function Cost = ModelSimulationCost(freeParams)
    global idealM B C D u simTime yIdeal
    % Set up the new spring object
    L = freeParams(1);
    t = freeParams(2);
    w = freeParams(3);
    r = freeParams(4);

    s = newSpring(L, t, w, r);
    s.kRatio = freeParams(5);
    s.predictKD();

    % Run lsim to determine response
    % B, C, and D remain the same
    A = [0, 1; -s.ks/idealM, -s.kd/idealM];

    curSys = ss(A, B, C, D);

    % u and t are the same as the ideal
    [y] = lsim(curSys, u, simTime);

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


A = [0, 1; -optimizedS.ks/idealM, -optimizedS.kd/idealM];

optimalSys = ss(A, B, C, D);

% u and t are the same as the ideal
[yOptimized, t_out] = lsim(optimalSys, u, simTime);

figure;
hold on
plot(t_out, yIdeal, "LineWidth", 10)
plot(t_out, yOptimized, '*k')
hold off

% For E = 2e9:
% Best params found:  0.1093    0.0572    0.0000    0.0937    0.0100

figure()
optimizedS.fillCoords();