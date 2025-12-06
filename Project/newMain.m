clc; clearvars -except optimizedSpring; close all;
addpath("src");
addpath("src/mcmcstat");
addpath("src/kde");

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

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FULL SET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Optimize the Parameters (Full Set)

set = 1:6;
% run the optimization
[optimizedSpring, h] = runOptimization(m, simTime, yIdeal, tIdeal, set);
hold off;
saveas(h, "Reports/FullParamSetOptimization.jpg");

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
%% Determine the Sensitivity of the Parameters (Full Set)
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

% Complex Step
[~, h] = runSensitivityComplexStep(m, yIdeal, tIdeal, simTime, fixedPoint, set);
saveas(h, "Reports/FullParamSetSensitivity.jpg");


%% UQ (Full Set)
yIdeal = yIdeal(:);
data.xdata = tIdeal;

ydata = [];

for i = 1:20
    randVals = 2*rand(numel(tIdeal), 1) - 1;
    randVals = randVals / 15;
    ydata = [ydata, randVals + yIdeal];
end
data.ydata = ydata;
initVals = fixedPoint;
% initVals = [0.41, 6e-3, .49, .3, 7.7, 9e9];
initNames = {'L', 't', 'w', 'r', 'alpha', 'E'};
h = runUQ(data, initVals, initNames, m, yIdeal, set);

saveas(h.h1, "Reports/FullParamSetInitialGuess.jpg");
saveas(h.h2, "Reports/FullParamSetChains.jpg");
saveas(h.h3, "Reports/FullParamSetChainPanel.jpg");
saveas(h.h4, "Reports/FullParamSetPairs.jpg");
% saveas(h.h5, "Reports/FullParamSetConfidence.jpg");

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% REDUCED SET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
set = [1:4, 6];
% run the optimization
[optimizedSpring, h] = runOptimization(m, simTime, yIdeal, tIdeal, set);
hold off;
saveas(h, "Reports/RedParamSetOptimization.jpg");

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
%% Determine the Sensitivity of the Parameters (RED Set)
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

% Complex Step
[~, h] = runSensitivityComplexStep(m, yIdeal, tIdeal, simTime, fixedPoint, set);
saveas(h, "Reports/RedParamSetSensitivity.jpg");


%% UQ (RED Set)
yIdeal = yIdeal(:);
data.xdata = tIdeal;

ydata = [];

for i = 1:20
    randVals = 2*rand(numel(tIdeal), 1) - 1;
    randVals = randVals / 15;
    ydata = [ydata, randVals + yIdeal];
end
data.ydata = ydata;
initVals = fixedPoint;
% initVals = [0.41, 6e-3, .49, .3, 7.7, 9e9];
initNames = {'L', 't', 'w', 'r', 'alpha', 'E'};
h = runUQ(data, initVals, initNames, m, yIdeal, set);

saveas(h.h1, "Reports/RedParamSetInitialGuess.jpg");
saveas(h.h2, "Reports/RedParamSetChains.jpg");
saveas(h.h3, "Reports/RedParamSetChainPanel.jpg");
saveas(h.h4, "Reports/RedParamSetPairs.jpg");
% saveas(h.h5, "Reports/RedParamSetConfidence.jpg");