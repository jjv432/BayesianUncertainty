clc; clear all; close all;
addpath("src");
%% Define the ideal response for the model
global idealM
idealKS = 200;
idealKD = 2;
idealM= 10;

[yIdeal, tIdeal] = getResponse(idealKS, idealKD);

figure()
plot(tIdeal, yIdeal, 'LineWidth', 10)
xlabel("Time (s)");
ylabel("Spring Height (m)");
title("Ideal Spring Response");
grid on
saveas(gcf, "Reports/IdealSpringResponse.jpg");

%% Setting up GA

% nvars = 5; % how many variables change
nvars = 4; % how many variables change

% current best: 0.0497    0.0007    2.9654e-07    0.0581    0.0100

% lower and upper bounds for each variable
% L, t, w, r, ratio b/w kp and kd
% LB= [0, 0, 0, 0, 0] + 1e-10;
% UB= [0.2, 0.02, .01, 0.06, .02];
LB= [0, 0, 0, 0] + 1e-10;
UB= [0.02, .01, 0.06, .02];

numparticles = 128;

options = optimoptions('ga', 'PopulationSize', numparticles, 'MaxGenerations', 400);

% Cost function handle
costFunctionHandle = @(freeParams) ModelSimulationCost(freeParams, yIdeal);

function Cost = ModelSimulationCost(fP, yIdeal)

    % s = newSpring(fP(1), fP(2), fP(3), fP(4));
    s = newSpring(0.0497, fP(1), fP(2), fP(3));
    % s.kRatio = fP(5);
    s.kRatio = fP(4);
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

%% Create the optimal spring
% L = OptimizedParams(1);
% t = OptimizedParams(2);
% w = OptimizedParams(3);
% r = OptimizedParams(4);
% optimizedS = newSpring(L, t, w, r);
% optimizedS.kRatio = OptimizedParams(5);
% optimizedS.predictKD();

% For 4 params, fixed point at: 0.0039    2.6096e-07    0.0261    0.0100
L = 0.0497;
t = OptimizedParams(1);
w = OptimizedParams(2);
r = OptimizedParams(3);
optimizedS = newSpring(L, t, w, r);
optimizedS.kRatio = OptimizedParams(4);
optimizedS.predictKD();

[yOptimized, t_out] = getResponse(optimizedS.ks, optimizedS.kd);

%% Plotting optimized


figure;
hold on
plot(t_out, yIdeal, "LineWidth", 10)
plot(t_out, yOptimized, '*k')
xlabel("Time (s)");
ylabel("Spring Height (m)");
title("Real and Ideal Spring Response");
grid on
% saveas(gcf, "Reports/RealAndIdealSpringResponse.jpg");
saveas(gcf, "Reports/Reduced_RealAndIdealSpringResponse.jpg");
hold off

%% Old code

% %%
% figure()
% optimizedS.fillCoords();
% 
% %%
% s = newSpring(0.1866, 0.0147, 1e-10, 0.0382);
% s.kRatio= .01;
% s.predictKD;
% 
% y = yOptimized;
% figure;
% for i = 1:numel(y)
%     cla;
%     s.inverseKinematics(y(i));
%     s.fillCoords;
%     drawnow;
% 
% end
% 
% %%
% % Constantly increasing F
% 
% forces = linspace(0, 2, 10);
% gca;
% for i = 1:numel(forces)
%     cla;
%     s.th3Response(forces(i));
%     s.fillCoords
%     drawnow;
% 
% end