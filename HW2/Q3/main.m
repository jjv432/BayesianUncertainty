clc; clearvars -except P psi; close all

load energy_data.mat
addpath("./mcmcstat/")

%% Part 1

%{
Setting up a particle swarm optimization to guess the coefficients the
model should use
%}

numVars = 4; % order of the model

% Bounds that the particles can guesss between
LB = -20 * ones(numVars,1);
UB = 20* ones(numVars, 1);

% Cost function used by the particle swarm
data.xdata = P;
data.ydata = psi;
costFunctionHandle = @(theta, numVars) CostFunction(theta,data);

% Run particle swarm
optimalTheta = particleswarm(costFunctionHandle, numVars, LB, UB);

% Create y vals based on the optimized coefficients
modelPsi = myPolynomialFunc(data, optimalTheta);

% Plot
figure()
hold on
plot(P, psi, 'DisplayName', 'Data')
plot(P, modelPsi, 'DisplayName', 'Model')
legend()

%% Part 2
% ssfun = @CostFunction;
% model.ssfun=ssfun;
% 
% % Chains
% 
% model.sigma2 = 1e-4;      %initial guess on variance
% model.S20 = model.sigma2; %prior for sigma2
% model.N0  = 1;            %prior accuracy for S20
% options.updatesigma = 1;  %update variance as part of the inference
% options.method = 'dram';  %this applies the DRAM algorithm
% model.N  = length(data.xdata); %number of data points
% 
% options.nsimu = 10000; %number of iterations in the Metropolis method
% [results, chain, s2chain]= mcmcrun(model,data,optimalTheta,options);
% chainstats(chain,results) %print chain statistics

%% Functions

% This function takes in x values of interest and polynomial coefficients
% and spits out corresponding y values
function yVals = myPolynomialFunc(data, coeff)
    if class(data) == "struct"
        xVals =  data.xdata;
    else
        xVals = data;
    end
    numParams = numel(coeff);

    for i = 1:numParams
        xMat(:, i) = xVals.^i;
    end

    yVals = xMat * coeff';
end

% Taking the difference between model data and experimental data as the
% cost
function cost = CostFunction(theta, data)

    simulatedY = myPolynomialFunc(data.xdata,theta);

    cost = sum(abs(data.ydata' - simulatedY));
end