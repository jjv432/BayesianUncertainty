clc; clearvars; close all

%{

H(P,theta) = alpha_1 * P^2 + alpha_11 * P^4 + alpha_111 * P^6
theta = [alpha_1, alpha_11, alpha_111]T
theta_nom = [-382.7, 760.3, 115.5]

Find sensitivity matrix S
Find fischer info F in domain [0, 0.8]
Compute rank of F and discuss identifyability of theta
Experiment w/ other polarization intervals to see if they affect parameter
identifiability.

%}

%% Find S

pVals = linspace(0, .8, 50); % full rank
pVals = linspace(-100, -80, 50); % not full rank
pVals = linspace(80, 100, 50); % not full rank
S = sensitivityMatrix(pVals);

function S = sensitivityMatrix(pVals)
    S(:, 1) = (pVals(:)).^2;
    S(:, 2) = (pVals(:)).^4;
    S(:, 3) = (pVals(:)).^6;
end

%% Find F

sigma = .1;
F = (1/sigma^2) * (S' * S);
rank = rank(F);

if rank == 3
    disp("F is full rank");
else
    disp("F is not full rank");
end