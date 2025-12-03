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

%% Optimize the Parameters

% run the optimization
optimizedSpring = runOptimization(m, simTime, yIdeal, tIdeal);
hold off;

% animate the behavior of the ideal spring
[y, t] = optimizedSpring.getResponse(simTime);

animate = 0;
if animate
    figure();
    for i = 1:10:numel(y)
        cla;
        optimizedSpring.inverseKinematics(y(i));
        optimizedSpring.fillCoords;
        drawnow;

    end
end
%% Determine the Sensitivity of the Parameters
% L, t, w, r, (m), alpha, E
L = optimizedSpring.L_;
t = optimizedSpring.t_;
w = optimizedSpring.w_;
r = optimizedSpring.r_;
alpha = optimizedSpring.alpha_;
E = optimizedSpring.E_;

fixedPoint(1) = L;
fixedPoint(2) = t;
fixedPoint(3) = w;
fixedPoint(4) = r;
fixedPoint(5) = alpha;
fixedPoint(6) = E;

%% Complex Step
runSensitivityComplexStep(m, yIdeal, tIdeal, simTime, fixedPoint);


%% Finite Diff
% fpSave = fixedPoint;
% fpSave(end) = fpSave(end) / 1e9;
% fpSave = round(fpSave, 2);
% 
% s = matrix2latex(fpSave);
% s = string(s);
% s = strrep(s, string(fpSave(end)), string(fpSave(end)) + "E9");
% fid = fopen('Reports/optimizedParams.tex', 'w');
% fprintf(fid, '%s', s);
% fclose(fid);
% runSensitivity(m, yIdeal, tIdeal, simTime, fixedPoint)