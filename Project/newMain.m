clc; clearvars -except optimizedSpring; close all;
addpath("src");

%% General
% All of these units are metric
m = 5;

maxTime = 5;
numSimPoints = 1e3;
simTime = linspace(0, maxTime, numSimPoints);

%% Define the ideal response for the model
idealKS = 200;
idealKD = 2;

[yIdeal, tIdeal] = getResponseIdeal(idealKS, idealKD, m, simTime);

%% Testing runOptimization.m

% run the optimization
optimizedSpring = runOptimization(m, simTime, yIdeal, tIdeal);
hold off;

% animate the behavior of the ideal spring
[y, t] = optimizedSpring.getResponse(simTime);

figure;
for i = 1:10:numel(y)
    cla;
    optimizedSpring.inverseKinematics(y(i));
    optimizedSpring.fillCoords;
    drawnow;

end

%% Testing runSensitivity.m
% L, t, w, r, (m), alpha
L = optimizedSpring.L_;
t = optimizedSpring.t_;
w = optimizedSpring.w_;
r = optimizedSpring.r_;
alpha = optimizedSpring.alpha_;

fixedPoint(1) = L;
fixedPoint(2) = t;
fixedPoint(3) = w;
fixedPoint(4) = r;
fixedPoint(5) = alpha;
runSensitivity(m, yIdeal, tIdeal, simTime, fixedPoint)