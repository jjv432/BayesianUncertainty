clc; clear; close all

load energy_data.mat

figure()
plot(P, psi, 'DisplayName', 'Data')
legend()

%% Part 1
numVars = 4;
LB = [0 0 0 0];
UB = [10, 10, 10, 10];
costFunctionHandle = @(theta, numVars) CostFunction(theta, P, psi);

optimalTheta = particleswarm(costFunctionHandle, numVars, LB, UB);

numParams = numel(optimalTheta);

for i = 1:numParams
    xVals(:, i) = P.^i;
end

simulatedY = xVals * optimalTheta';

plot(P, simulatedY);

function cost = CostFunction(theta, xData, yData)

    xData = xData(:);
    numParams = numel(theta);

    for i = 1:numParams
        xVals(:, i) = xData.^i;
    end

    simulatedY = xVals * theta';

    cost = sum(abs(yData' - simulatedY));
end